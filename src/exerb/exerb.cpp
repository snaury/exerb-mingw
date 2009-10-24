// $Id: exerb.cpp,v 1.196 2008/06/13 23:52:29 arton Exp $

#include <ruby.h>
#include <crtdbg.h>

#include "exerb.h"
#include "module.h"
#include "utility.h"
#include "resource.h"

#ifdef RUBY19
extern "C" {
#include <yarvcore.h>
}
#endif

////////////////////////////////////////////////////////////////////////////////

typedef struct {
	char *filepath;
	HMODULE handle;
} LOADED_LIBRARY_ENTRY;

typedef struct {
	DWORD base_of_file;
	IMAGE_DOS_HEADER *dos_header;
	IMAGE_NT_HEADERS *nt_headers;
	IMAGE_SECTION_HEADER *section;
	DWORD base_of_import_table;
	DWORD delta_of_import_table;
	DWORD base_of_name_pool;
	DWORD size_of_name_pool;
} IMPORT_TABLE_INFO;

////////////////////////////////////////////////////////////////////////////////

VALUE rb_mExerbRuntime      = 0;
VALUE rb_eExerbRuntimeError = 0;

ARCHIVE_HEADER    *g_archive_header    = NULL;
NAME_TABLE_HEADER *g_name_table_header = NULL;
FILE_TABLE_HEADER *g_file_table_header = NULL;

int g_loaded_library_count = 0;
LOADED_LIBRARY_ENTRY g_loaded_library_table[32] = {0};
LOADED_LIBRARY_ENTRY g_pre_loaded_library_table[8] = {0};

int g_loaded_resource_count = 0;
HMODULE g_loaded_resource_table[4] = {0};

extern "C" VALUE rb_load_path;
extern "C" VALUE rb_argv0;
extern "C" VALUE rb_progname;

////////////////////////////////////////////////////////////////////////////////

int exerb_main(int argc, char** argv, void (*on_init)(VALUE, VALUE, VALUE), void (*on_fail)(VALUE));
static VALUE exerb_main_in_protect(VALUE replace_io);
static void exerb_mapping();
static void exerb_set_script_name(char* name);
static void exerb_setup_kcode();
static void exerb_setup_resource_library();
static void exerb_execute();
static void exerb_cleanup();
extern "C" VALUE exerb_require(VALUE fname);
static bool exerb_find_file_pre_loaded(const VALUE filename, VALUE *feature, LOADED_LIBRARY_ENTRY **loaded_library_entry);
static bool exerb_find_file_inside(const VALUE filename, WORD *id, VALUE *feature, VALUE *realname);
static bool exerb_find_file_outside(const VALUE filename, VALUE *feature, VALUE *realname);
static VALUE exerb_load_ruby_script(const FILE_ENTRY_HEADER *file_entry);
static VALUE exerb_load_ruby_script(const char *filepath);
#ifdef RUBY19
static VALUE exerb_load_compiled_script(const FILE_ENTRY_HEADER *file_entry);
#endif
static void exerb_load_extension_library(const FILE_ENTRY_HEADER *file_entry);
static void exerb_load_extension_library(const char *filepath);
static HMODULE exerb_load_library(const FILE_ENTRY_HEADER *file_entry);
static HMODULE exerb_load_library(const char *base_of_file, const int size_of_file, const char* filepath, bool no_replace_function);
static HMODULE exerb_preload_library(const FILE_ENTRY_HEADER *file_entry);
static bool exerb_replace_import_dll(const char *base_of_file);
static void exerb_replace_import_dll_name(IMPORT_TABLE_INFO *info, const char *src_name, const char* new_name);
static bool exerb_get_import_table_info(const char *base_of_file, IMPORT_TABLE_INFO *info);
static IMAGE_SECTION_HEADER* exerb_get_enclosing_section_header(const IMAGE_NT_HEADERS *nt_headers, const DWORD rva);
static void exerb_call_initialize_function(const HMODULE handle, const char *filepath);
static bool exerb_find_resource(const DWORD base_of_image, const int type, const int id, DWORD *base_of_item, DWORD *size_of_item);

static void exerb_replace_import_function(const HMODULE module);
static bool exerb_replace_import_function_thunk(const HMODULE module, const FARPROC src_proc, const FARPROC new_proc);
static HMODULE WINAPI exerb_hook_load_library(LPCTSTR filename);
static HMODULE WINAPI exerb_hook_load_library_ex(LPCTSTR filename, HANDLE file, DWORD flags);
static HMODULE WINAPI exerb_hook_get_module_handle(LPCTSTR filename);
static FARPROC WINAPI exerb_hook_get_proc_address(HMODULE module, LPCTSTR procname);

////////////////////////////////////////////////////////////////////////////////

int
exerb_main(int argc, char** argv, void (*on_init)(VALUE, VALUE, VALUE), void (*on_fail)(VALUE))
{
	::NtInitialize(&argc, &argv);
	::ruby_init();
	argc = ::rb_w32_cmdvector(::GetCommandLine(), &argv);
	::ruby_set_argv(argc - 1, argv + 1);
	::exerb_set_script_name("exerb");
	::rb_ary_push(rb_load_path, ::rb_str_new2("."));

	int state = 0, result_code = 0;
	::rb_protect(exerb_main_in_protect, UINT2NUM((DWORD)on_init), &state);

	if ( state ) {
#ifdef RUBY19
		VALUE errinfo = GET_THREAD()->errinfo;
#else
		VALUE errinfo = ruby_errinfo;
#endif
		if ( ::rb_obj_is_kind_of(errinfo, rb_eSystemExit) ) {
			result_code = FIX2INT(::rb_iv_get(errinfo, "status"));
		} else {
			on_fail(errinfo);
			result_code = 1;
		}
	}

	::ruby_finalize();
	::exerb_cleanup();

	return result_code;
}

static VALUE
exerb_main_in_protect(VALUE on_init_proc)
{
	::Init_ExerbRuntime();

	void (*on_init)(VALUE, VALUE, VALUE) = (void(*)(VALUE, VALUE, VALUE))NUM2UINT(on_init_proc);
	if ( on_init ) on_init(rb_stdin, rb_stdout, rb_stderr);

	::exerb_mapping();
	::exerb_setup_kcode();
	::exerb_setup_resource_library();
	::exerb_execute();

	return Qnil;
}

static void
exerb_mapping()
{
	const DWORD base_of_image = (DWORD)::GetModuleHandle(NULL);
	DWORD base_of_archive = 0, size_of_archive = 0;
	if ( !::exerb_find_resource(base_of_image, RT_EXERB, ID_EXERB, &base_of_archive, &size_of_archive) ) {
		::rb_raise(rb_eExerbRuntimeError, "The executable hasn't an archive.");
	}

	g_archive_header = (ARCHIVE_HEADER*)base_of_archive;
	if ( g_archive_header->signature1 != ARCHIVE_HEADER_SIGNATURE1 ||
		 g_archive_header->signature2 != ARCHIVE_HEADER_SIGNATURE2 ) {
		::rb_raise(rb_eExerbRuntimeError, "The executable has invalid signature of archive header.");
	}
	if ( g_archive_header->offset_of_name_table   == 0 ||
		 g_archive_header->offset_of_file_table   == 0 ) {
		::rb_raise(rb_eExerbRuntimeError, "The executable has invalid archive header.");
	}

	g_name_table_header = (NAME_TABLE_HEADER*)(base_of_archive + g_archive_header->offset_of_name_table);
	g_file_table_header = (FILE_TABLE_HEADER*)(base_of_archive + g_archive_header->offset_of_file_table);

	if ( g_name_table_header->signature != NAME_TABLE_HEADER_SIGNATURE ) {
		::rb_raise(rb_eExerbRuntimeError, "The executable has invalid signature of the name table header.");
	}
	if ( g_file_table_header->signature != FILE_TABLE_HEADER_SIGNATURE ) {
		::rb_raise(rb_eExerbRuntimeError, "The executable has invalid signature of the file table header.");
	}
}

static void
exerb_set_script_name(char* name)
{
	::ruby_script(name);
	rb_argv0 = rb_progname;
}

static void
exerb_setup_kcode()
{
	switch ( g_archive_header->kcode ) {
	case ARCHIVE_HEADER_OPTIONS_KCODE_NONE: ::rb_set_kcode("n"); break;
	case ARCHIVE_HEADER_OPTIONS_KCODE_EUC:  ::rb_set_kcode("e"); break;
	case ARCHIVE_HEADER_OPTIONS_KCODE_SJIS: ::rb_set_kcode("s"); break;
	case ARCHIVE_HEADER_OPTIONS_KCODE_UTF8: ::rb_set_kcode("u"); break;
	}
}

static void
exerb_setup_resource_library()
{
	FILE_ENTRY_HEADER *file_entry = ::exerb_get_first_file_entry();

	for ( int i = 0; i < g_file_table_header->number_of_headers; i++, file_entry++ ) {
		if ( file_entry->type_of_file == FILE_ENTRY_HEADER_TYPE_RESOURCE_LIBRARY ) {
			if ( g_loaded_resource_count > sizeof(g_loaded_resource_table) / sizeof(HMODULE) ) {
				::rb_raise(rb_eExerbRuntimeError, "the loaded recourse table is too big.");
			}

			g_loaded_resource_table[g_loaded_resource_count] = ::exerb_load_library(file_entry);
			g_loaded_resource_count++;
		}
	}
}

static void
exerb_execute()
{
	FILE_ENTRY_HEADER *file_entry = ::exerb_get_first_file_entry();

	for ( int i = 0; i < g_file_table_header->number_of_headers; i++, file_entry++ ) {
		if ( file_entry->type_of_file == FILE_ENTRY_HEADER_TYPE_RUBY_SCRIPT ) {
			::exerb_set_script_name(::exerb_get_name_from_entry(::exerb_find_name_entry(file_entry->id)));
			::exerb_load_ruby_script(file_entry);
			return;
#ifdef RUBY19
		} else if ( file_entry->type_of_file == FILE_ENTRY_HEADER_TYPE_COMPILED_SCRIPT ) {
			::exerb_set_script_name(::exerb_get_name_from_entry(::exerb_find_name_entry(file_entry->id)));
			::exerb_load_compiled_script(file_entry);
			return;
#endif
		}
	}

	::rb_raise(rb_eExerbRuntimeError, "The startup script was not found.");
}

static void
exerb_cleanup()
{
	for ( int i = g_loaded_library_count; i > 0; i-- ) {
		const LOADED_LIBRARY_ENTRY *entry = &g_loaded_library_table[i - 1];
		char filepath[MAX_PATH] = "";
		::GetModuleFileName(entry->handle, filepath, sizeof(filepath));
		::FreeLibrary(entry->handle);
		::DeleteFile(filepath);
		delete[] entry->filepath;
	}
}

extern "C" VALUE
exerb_require(VALUE fname)
{
	::Check_SafeStr(fname);

	LOADED_LIBRARY_ENTRY *loaded_library_entry = NULL;
	WORD id = 0;
	VALUE feature = Qnil, realname = Qnil;

	if ( ::exerb_find_file_pre_loaded(fname, &feature, &loaded_library_entry) ) {
		::exerb_call_initialize_function(loaded_library_entry->handle, loaded_library_entry->filepath);
		delete[] loaded_library_entry->filepath;
		loaded_library_entry->filepath = NULL;
		loaded_library_entry->handle   = NULL;
		::rb_provide(RSTRING_PTR(feature));
		return Qtrue;
	} else if ( ::exerb_find_file_inside(fname, &id, &feature, &realname) ) {
		if ( ::rb_provided(RSTRING_PTR(feature)) ) return Qfalse;

		FILE_ENTRY_HEADER *file_entry = ::exerb_find_file_entry(id);

		switch ( file_entry->type_of_file ) {
		case FILE_ENTRY_HEADER_TYPE_RUBY_SCRIPT:
			::exerb_load_ruby_script(file_entry);
			::rb_provide(RSTRING_PTR(feature));
			return Qtrue;
#ifdef RUBY19
		case FILE_ENTRY_HEADER_TYPE_COMPILED_SCRIPT:
			::exerb_load_compiled_script(file_entry);
			::rb_provide(RSTRING_PTR(feature));
			return Qtrue;
#endif
		case FILE_ENTRY_HEADER_TYPE_EXTENSION_LIBRARY:
			::exerb_load_extension_library(file_entry);
			::rb_provide(RSTRING_PTR(feature));
			return Qtrue;
		}
	} else if ( ::exerb_find_file_outside(fname, &feature, &realname) ) {
		if ( ::rb_provided(RSTRING_PTR(feature)) ) return Qfalse;

		const char *ext = ::strrchr(RSTRING_PTR(feature), '.');

		if ( ::stricmp(ext, ".rb") == 0 ) {
			::exerb_load_ruby_script(RSTRING_PTR(realname));
			::rb_provide(RSTRING_PTR(feature));
			return Qtrue;
		} else if ( ::stricmp(ext, ".so") == 0 ) {
			::exerb_load_extension_library(RSTRING_PTR(realname));
			::rb_provide(RSTRING_PTR(feature));
			return Qtrue;
		}
	}

	::rb_raise(rb_eLoadError, "No such file to load -- %s", RSTRING_PTR(fname));

	return Qfalse;
}

static bool
exerb_find_file_pre_loaded(const VALUE filename, VALUE *feature, LOADED_LIBRARY_ENTRY **loaded_library_entry)
{
	const char *fname = RSTRING_PTR(filename);

	for ( int i = 0; i < sizeof(g_pre_loaded_library_table) / sizeof(LOADED_LIBRARY_ENTRY); i++ ) {
		const char *name = g_pre_loaded_library_table[i].filepath;
		if ( !name ) continue;

		if ( ::stricmp(name, fname) == 0 ) {
			*feature              = ::rb_str_new2(name);
			*loaded_library_entry = &g_pre_loaded_library_table[i];
			return true;
		} else if ( ::exerb_cmp_filename_with_ext(name, fname, "so") ) {
			*feature              = ::rb_str_new2(name);
			*loaded_library_entry = &g_pre_loaded_library_table[i];
			return true;
		} else if ( ::exerb_cmp_filename_with_ext(name, fname, "dll") ) {
			*feature              = ::rb_str_concat(::rb_str_new2(fname), ::rb_str_new2(".so"));
			*loaded_library_entry = &g_pre_loaded_library_table[i];
			return true;
		}
	}

	return false;
}

static bool
exerb_find_file_inside(const VALUE filename, WORD *id, VALUE *feature, VALUE *realname)
{
	const char *fname = STR2CSTR(filename);

	NAME_ENTRY_HEADER *name_entry = ::exerb_get_first_name_entry();

	for ( int i = 0; i < g_name_table_header->number_of_headers; i++, name_entry++ ) {
		const char *name = ::exerb_get_name_from_entry(name_entry);

		if ( ::strcmp(name, fname) == 0 ) {
			*id       = name_entry->id;
			*feature  = ::rb_str_new2(name);
			*realname = ::rb_str_new2(name);
			return true;
		} else if ( ::exerb_cmp_filename_with_ext(name, fname, "rb") ) {
			*id       = name_entry->id;
			*feature  = ::rb_str_new2(name);
			*realname = ::rb_str_new2(name);
			return true;
		} else if ( ::exerb_cmp_filename_with_ext(name, fname, "so") ) {
			*id       = name_entry->id;
			*feature  = ::rb_str_new2(name);
			*realname = ::rb_str_new2(name);
			return true;
		} else if ( ::exerb_cmp_filename_with_ext(name, fname, "dll") ) {
			*id       = name_entry->id;
			*feature  = ::rb_str_concat(::rb_str_new2(fname), ::rb_str_new2(".so"));
			*realname = ::rb_str_new2(name);
			return true;
		}
	}

	*id       = 0;
	*feature  = Qnil;
	*realname = Qnil;

	return false;
}

static bool
exerb_find_file_outside(const VALUE filename, VALUE *feature, VALUE *realname)
{
	const VALUE filename_rb  = ::rb_str_concat(::rb_str_dup(filename), ::rb_str_new2(".rb"));
	const VALUE filename_so  = ::rb_str_concat(::rb_str_dup(filename), ::rb_str_new2(".so"));
	const VALUE filename_dll = ::rb_str_concat(::rb_str_dup(filename), ::rb_str_new2(".dll"));

	if ( *realname = ::rb_find_file(*feature = filename)    ) return true;
	if ( *realname = ::rb_find_file(*feature = filename_rb) ) return true;
	if ( *realname = ::rb_find_file(*feature = filename_so) ) return true;
	if ( *realname = ::rb_find_file(filename_dll) ) { *feature = filename_so; return true; }

	*feature  = Qnil;
	*realname = Qnil;

	return false;
}

static VALUE
exerb_load_ruby_script(const FILE_ENTRY_HEADER *file_entry)
{
	static const ID    id_eval = ::rb_intern("eval");
	static const VALUE binding = ::rb_const_get(rb_mKernel, ::rb_intern("TOPLEVEL_BINDING"));
	static const VALUE lineno  = INT2FIX(1);
	
	const VALUE code = ::rb_str_new(::exerb_get_file_from_entry(file_entry), file_entry->size_of_file);
	const VALUE name = ::rb_str_new2(::exerb_get_name_from_entry(::exerb_find_name_entry(file_entry->id)));

	return ::rb_funcall(rb_mKernel, id_eval, 4, code, binding, name, lineno);
}

static VALUE
exerb_load_ruby_script(const char *filepath)
{
	::rb_load(::rb_str_new2(filepath), 0);
	return Qnil;
}

#ifdef RUBY19
static VALUE
exerb_load_compiled_script(const FILE_ENTRY_HEADER *file_entry)
{
	static const ID id_load = ::rb_intern("load");
	static const ID id_eval = ::rb_intern("eval");
	const VALUE code     = ::rb_str_new(::exerb_get_file_from_entry(file_entry), file_entry->size_of_file);
	const VALUE iseq_ary = ::rb_marshal_load(code);
	const VALUE iseq     = ::rb_funcall(rb_cISeq, id_load, 1, iseq_ary);

	return ::rb_funcall(iseq, id_eval, 0);
}
#endif

static void
exerb_load_extension_library(const FILE_ENTRY_HEADER *file_entry)
{
	const HMODULE handle = ::exerb_load_library(file_entry);
	const char *filepath = ::exerb_get_name_from_entry(::exerb_find_name_entry(file_entry->id));
	::exerb_call_initialize_function(handle, filepath);
}

static void
exerb_load_extension_library(const char *filepath)
{
	const HANDLE file = ::exerb_fopen_for_read(filepath);
	const DWORD  size = ::exerb_fsize(file);
	char *buffer = new char[size];
	::exerb_fread(file, buffer, size);
	::exerb_fclose(file);

	const HMODULE handle = ::exerb_load_library(buffer, size, filepath, false);
	::exerb_call_initialize_function(handle, filepath);

	delete[] buffer;
}

static HMODULE
exerb_load_library(const FILE_ENTRY_HEADER *file_entry)
{
	const char *base_of_file = ::exerb_get_file_from_entry(file_entry);
	const char *filepath     = ::exerb_get_name_from_entry(::exerb_find_name_entry(file_entry->id));
	return ::exerb_load_library(base_of_file, file_entry->size_of_file, filepath, (bool)file_entry->flag_no_replace_function);
}

static HMODULE
exerb_load_library(const char *base_of_file, const int size_of_file, const char* filepath, bool no_replace_function)
{
	if ( g_loaded_library_count > sizeof(g_loaded_library_table) / sizeof(LOADED_LIBRARY_ENTRY) ) {
		::rb_raise(rb_eExerbRuntimeError, "the loaded library table is too big.");
	}

	DWORD protect = 0, dummy = 0;
	::VirtualProtect((void*)base_of_file, size_of_file, PAGE_READWRITE, &protect);
	::exerb_replace_import_dll(base_of_file);
	::VirtualProtect((void*)base_of_file, size_of_file, protect, &dummy);

	char tmp_filepath[MAX_PATH]  = "";
	::exerb_create_tmpfile("exerb", tmp_filepath, base_of_file, size_of_file);

	const HMODULE handle = ::LoadLibraryEx(tmp_filepath, NULL, LOAD_WITH_ALTERED_SEARCH_PATH);
	if ( !handle ) {
		DWORD error = ::GetLastError();
		::DeleteFile(tmp_filepath);
		::exerb_raise_runtime_error(error);
	}

	g_loaded_library_table[g_loaded_library_count].filepath = ::exerb_strdup(filepath);
	g_loaded_library_table[g_loaded_library_count].handle   = handle;
	g_loaded_library_count++;

	if ( !no_replace_function ) ::exerb_replace_import_function(handle);

	return handle;
}

static HMODULE
exerb_preload_library(const FILE_ENTRY_HEADER *file_entry)
{
	NAME_ENTRY_HEADER *name_entry = ::exerb_find_name_entry(file_entry->id);
	const char *name = ::exerb_get_name_from_entry(name_entry);

	for ( int i = 0; i < g_loaded_library_count; i++ ) {
		if ( g_loaded_library_table[i].filepath && ::stricmp(g_loaded_library_table[i].filepath, name) == 0 ) {
			return g_loaded_library_table[i].handle;
		}
	}

	HMODULE module = ::exerb_load_library(file_entry);

	if ( file_entry->type_of_file == FILE_ENTRY_HEADER_TYPE_EXTENSION_LIBRARY ) {
		for ( int i = 0; i < sizeof(g_pre_loaded_library_table) / sizeof(LOADED_LIBRARY_ENTRY); i++ ) {
			if ( !g_pre_loaded_library_table[i].handle ) {
				g_pre_loaded_library_table[i].filepath = ::exerb_strdup(name);
				g_pre_loaded_library_table[i].handle   = module;
				break;
			}
		}
	}

	return module;
}

static bool
exerb_replace_import_dll(const char *base_of_file)
{
	IMPORT_TABLE_INFO info = {0};
	if ( !::exerb_get_import_table_info(base_of_file, &info) ) return false;

	char self_filepath[MAX_PATH] = "";
	const char *self_filename = ::exerb_get_self_filepath(self_filepath, sizeof(self_filepath));

	// FIXME: msvcrt-ruby19.dll に対応させる
	// FIXME: msvcrt-ruby??.dll 以外のRubyライブラリにリンクされていた場合は、例外とする
	// FIXME: ランタイム版コアを使用している場合は、exerb??.dllにリンクする
	::exerb_replace_import_dll_name(&info, "exerb_dummy_module.dll", self_filename); // for an exerb plug-in
	::exerb_replace_import_dll_name(&info, "ruby.exe",               self_filename); // for an extension library on static linked ruby
#ifdef RUBY19
	::exerb_replace_import_dll_name(&info, "msvcrt-ruby19.dll",      self_filename); // for an extension library on dynamic linked ruby
#else
	::exerb_replace_import_dll_name(&info, "msvcrt-ruby18.dll",      self_filename); // for an extension library on dynamic linked ruby
	::exerb_replace_import_dll_name(&info, "cygwin-ruby18.dll",      self_filename); // for experiment
	::exerb_replace_import_dll_name(&info, "cygruby18.dll",          self_filename); // for experiment
#endif

	return true;
}

static void
exerb_replace_import_dll_name(IMPORT_TABLE_INFO *info, const char *src_name, const char* new_name)
{
	const DWORD base_of_name = info->base_of_file - info->delta_of_import_table;
	const DWORD size_of_new_name = ::strlen(new_name);

	IMAGE_IMPORT_DESCRIPTOR *first_descriptor = (IMAGE_IMPORT_DESCRIPTOR*)(info->base_of_file + info->base_of_import_table);

	for ( IMAGE_IMPORT_DESCRIPTOR *descriptor = first_descriptor; descriptor->Name; descriptor++ ) {
		char *name = (char*)(base_of_name + descriptor->Name);

		if ( ::stricmp(name, src_name) == 0 ) {
			bool found = false;
			for ( IMAGE_IMPORT_DESCRIPTOR *desc = first_descriptor; desc->Name; desc++ ) {
				if ( ::strcmp((char*)(base_of_name + desc->Name), new_name) == 0 ) {
					descriptor->Name = desc->Name;
					found = true;
					break;
				}
			}
			if ( found ) continue;

			if ( ::strlen(name) >= size_of_new_name ) {
				::strcpy(name, new_name);
			} else if ( size_of_new_name + 1 <= info->size_of_name_pool ) {
				DWORD address_of_new_name = info->base_of_name_pool - (size_of_new_name + 1);

				::strcpy((char*)(info->base_of_file + address_of_new_name), new_name);
				descriptor->Name = address_of_new_name + info->delta_of_import_table;

				info->base_of_name_pool -= size_of_new_name + 1;
				info->size_of_name_pool -= size_of_new_name + 1;
			} else {
				::rb_raise(rb_eLoadError, "Couldn't modify DLL's name in the import table. The name of the executable file is too long.");
			}
		} else if ( FILE_ENTRY_HEADER *file_entry = ::exerb_find_file_entry(name) ) {
			if ( file_entry->type_of_file == FILE_ENTRY_HEADER_TYPE_EXTENSION_LIBRARY ||
				 file_entry->type_of_file == FILE_ENTRY_HEADER_TYPE_DYNAMIC_LIBRARY ) {
				HMODULE module = ::exerb_preload_library(file_entry);
				char filepath[MAX_PATH] = "";
				const char *filename = ::exerb_get_module_filepath(module, filepath, sizeof(filepath));
				::exerb_replace_import_dll_name(info, name, filename);
			}
		}
	}
}

static bool
exerb_get_import_table_info(const char *base_of_file, IMPORT_TABLE_INFO *info)
{
	info->base_of_file = (DWORD)base_of_file;
	info->dos_header   = (IMAGE_DOS_HEADER*)info->base_of_file;
	info->nt_headers   = (IMAGE_NT_HEADERS*)(info->base_of_file + info->dos_header->e_lfanew);
	
	const DWORD rva_of_import_table = info->nt_headers->OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT].VirtualAddress;

	info->section = ::exerb_get_enclosing_section_header(info->nt_headers, rva_of_import_table);
	if ( !info->section ) return false;

	info->delta_of_import_table = info->section->VirtualAddress - info->section->PointerToRawData;
	info->base_of_import_table  = rva_of_import_table - info->delta_of_import_table;

	if ( ::strnicmp((char*)info->section->Name, ".idata", 8) == 0 ||  // for Boland's Compiler
	     ::strnicmp((char*)info->section->Name, ".rdata", 8) == 0 ) { // for Microsoft's Compiler
		info->base_of_name_pool = info->section->PointerToRawData + info->section->SizeOfRawData;
		info->size_of_name_pool = info->section->SizeOfRawData    - info->section->Misc.VirtualSize;
	} else {
		info->base_of_name_pool = 0;
		info->size_of_name_pool = 0;
	}

	return true;
}

static IMAGE_SECTION_HEADER*
exerb_get_enclosing_section_header(const IMAGE_NT_HEADERS *nt_headers, const DWORD rva)
{
	IMAGE_SECTION_HEADER *section = IMAGE_FIRST_SECTION(nt_headers);

	for ( int i = 0; i < nt_headers->FileHeader.NumberOfSections; i++, section++ ) {
		if ( (rva >= section->VirtualAddress) && (rva < (section->VirtualAddress + section->Misc.VirtualSize)) ) {
			return section;
		}
	}

	return NULL;
}

static void
exerb_call_initialize_function(const HMODULE handle, const char *filepath)
{
	const char *filename = ::exerb_get_filename(filepath);
	char funcname[128] = "Init_";
	::strncat(funcname, filename, sizeof(funcname) - ::strlen(funcname) - 1);

	char *ext = ::strrchr(funcname, '.');
	if ( ext && (::stricmp(ext, ".so") == 0 || ::stricmp(ext, ".dll") == 0) ) {
		*ext = '\0';
	}

	void (*init_proc)(void) = (void (*)(void))::GetProcAddress(handle, funcname);
	if ( !init_proc ) ::rb_raise(rb_eExerbRuntimeError, "Couldn't call the initialize function in the extension library. --- %s(%s)", filepath, funcname);

	(*init_proc)();
}

static bool
exerb_find_resource(const DWORD base_of_image, const int type, const int id, DWORD *base_of_item, DWORD *size_of_item)
{
	const IMAGE_DOS_HEADER *dos_header = (IMAGE_DOS_HEADER*)base_of_image;
	const IMAGE_NT_HEADERS *nt_headers = (IMAGE_NT_HEADERS*)(base_of_image + dos_header->e_lfanew);

	const DWORD base_of_resource = base_of_image + nt_headers->OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_RESOURCE].VirtualAddress;
	if ( base_of_resource == base_of_image ) return false;

	const IMAGE_RESOURCE_DIRECTORY       *root_dir     = (IMAGE_RESOURCE_DIRECTORY*)base_of_resource;
	const IMAGE_RESOURCE_DIRECTORY_ENTRY *root_entries = (IMAGE_RESOURCE_DIRECTORY_ENTRY*)(root_dir + 1);

	for ( WORD i = 0; i < root_dir->NumberOfNamedEntries + root_dir->NumberOfIdEntries; i++ ) {
		if ( !root_entries[i].NameIsString && root_entries[i].Id == type ) {
			const IMAGE_RESOURCE_DIRECTORY       *type_dir     = (IMAGE_RESOURCE_DIRECTORY*)(base_of_resource + root_entries[i].OffsetToDirectory);
			const IMAGE_RESOURCE_DIRECTORY_ENTRY *type_entries = (IMAGE_RESOURCE_DIRECTORY_ENTRY*)(type_dir + 1);

			for ( WORD j = 0; j < type_dir->NumberOfNamedEntries + type_dir->NumberOfIdEntries; j++ ) {
				if ( !type_entries[j].NameIsString && type_entries[j].Id == id ) {
					const IMAGE_RESOURCE_DIRECTORY       *item_dir     = (IMAGE_RESOURCE_DIRECTORY*)(base_of_resource + type_entries[j].OffsetToDirectory);
					const IMAGE_RESOURCE_DIRECTORY_ENTRY *item_entries = (IMAGE_RESOURCE_DIRECTORY_ENTRY*)(item_dir + 1);
					const IMAGE_RESOURCE_DATA_ENTRY      *data_entry   = (IMAGE_RESOURCE_DATA_ENTRY*)(base_of_resource + item_entries[0].OffsetToData);

					if ( base_of_item ) *base_of_item = base_of_image + data_entry->OffsetToData;
					if ( size_of_item ) *size_of_item = data_entry->Size;

					return true;
				}
			}
		}
	}

	return false;
}

////////////////////////////////////////////////////////////////////////////////

static void
exerb_replace_import_function(const HMODULE module)
{
	static const HMODULE kernel32              = ::GetModuleHandle("kernel32.dll");
	static const FARPROC load_library_proc     = ::GetProcAddress(kernel32, "LoadLibraryA");
	static const FARPROC load_library_ex_proc  = ::GetProcAddress(kernel32, "LoadLibraryExA");
	static const FARPROC get_module_handle     = ::GetProcAddress(kernel32, "GetModuleHandleA");
	static const FARPROC get_proc_address_proc = ::GetProcAddress(kernel32, "GetProcAddress");

	::exerb_replace_import_function_thunk(module, load_library_proc,     (FARPROC)::exerb_hook_load_library);
	::exerb_replace_import_function_thunk(module, load_library_ex_proc,  (FARPROC)::exerb_hook_load_library_ex);
	::exerb_replace_import_function_thunk(module, get_module_handle,     (FARPROC)::exerb_hook_get_module_handle);
	::exerb_replace_import_function_thunk(module, get_proc_address_proc, (FARPROC)::exerb_hook_get_proc_address);
}

static bool
exerb_replace_import_function_thunk(const HMODULE module, const FARPROC src_proc, const FARPROC new_proc)
{
	const DWORD base_of_image = (DWORD)module;
	const IMAGE_DOS_HEADER *dos_header = (IMAGE_DOS_HEADER*)base_of_image;
	const IMAGE_NT_HEADERS *nt_headers = (IMAGE_NT_HEADERS*)(base_of_image + dos_header->e_lfanew);

	const DWORD base_of_import = base_of_image + nt_headers->OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT].VirtualAddress;
	if ( base_of_import == base_of_image ) return false;

	for ( IMAGE_IMPORT_DESCRIPTOR *desc = (IMAGE_IMPORT_DESCRIPTOR*)base_of_import; desc->Name; desc++ ) {
		for ( DWORD *thunk = (DWORD*)(base_of_image + desc->FirstThunk); *thunk; thunk++ ) {
			if ( *thunk == (DWORD)src_proc ) {
				DWORD protect = 0, dummy = 0;
				::VirtualProtect(thunk, sizeof(DWORD), PAGE_READWRITE, &protect);
				*thunk = (DWORD)new_proc;
				::VirtualProtect(thunk, sizeof(DWORD), protect, &dummy);
				return true;
			}
		}
	}

	return false;
}

static HMODULE WINAPI
exerb_hook_load_library(LPCTSTR filename)
{
	_RPT1(_CRT_WARN, "exerb_hook_load_library('%s')\n", filename);

	if ( filename ) {
		if ( ::stricmp(filename, "msvcrt-ruby18") == 0 || ::stricmp(filename, "msvcrt-ruby18.dll") == 0 ) {
			return ::GetModuleHandle(NULL);
		} else if ( FILE_ENTRY_HEADER *file_entry = ::exerb_find_file_entry(filename, "dll") ) {
			if ( file_entry->type_of_file == FILE_ENTRY_HEADER_TYPE_EXTENSION_LIBRARY ||
				 file_entry->type_of_file == FILE_ENTRY_HEADER_TYPE_DYNAMIC_LIBRARY ) {
				return ::exerb_preload_library(file_entry);
			}
		}
	}

	return ::LoadLibrary(filename);
}

static HMODULE WINAPI
exerb_hook_load_library_ex(LPCTSTR filename, HANDLE file, DWORD flags)
{
	_RPT3(_CRT_WARN, "exerb_hook_load_library_ex('%s', %i, %i)\n", filename, file, flags);

	if ( filename ) {
		if ( ::stricmp(filename, "msvcrt-ruby18") == 0 || ::stricmp(filename, "msvcrt-ruby18.dll") == 0 ) {
			return ::GetModuleHandle(NULL);
		} else if ( FILE_ENTRY_HEADER *file_entry = ::exerb_find_file_entry(filename, "dll") ) {
			if ( file_entry->type_of_file == FILE_ENTRY_HEADER_TYPE_EXTENSION_LIBRARY ||
				 file_entry->type_of_file == FILE_ENTRY_HEADER_TYPE_DYNAMIC_LIBRARY ) {
				return ::exerb_preload_library(file_entry);
			}
		}
	}

	return ::LoadLibraryEx(filename, file, flags);
}

static HMODULE WINAPI
exerb_hook_get_module_handle(LPCTSTR filename)
{
	_RPT1(_CRT_WARN, "exerb_hook_get_module_handle('%s')\n", filename);

	if ( filename && (::stricmp(filename, "msvcrt-ruby18")     == 0 ||
	                  ::stricmp(filename, "msvcrt-ruby18.dll") == 0) ) {
		return ::GetModuleHandle(NULL);
	}

	return ::GetModuleHandle(filename);
}

static FARPROC WINAPI
exerb_hook_get_proc_address(HMODULE module, LPCTSTR procname)
{
	_RPT2(_CRT_WARN, "exerb_hook_get_proc_address(0x%08X, '%s')\n", module, procname);

	static HMODULE kernel32 = ::GetModuleHandle("kernel32.dll");

	// FIXME: 序数によるインポートに対応する

	if ( module == kernel32 ) {
		if      ( ::strcmp(procname, "LoadLibraryA")     == 0 ) return (FARPROC)::exerb_hook_load_library;
		else if ( ::strcmp(procname, "LoadLibraryExA")   == 0 ) return (FARPROC)::exerb_hook_load_library_ex;
		else if ( ::strcmp(procname, "GetModuleHandleA") == 0 ) return (FARPROC)::exerb_hook_get_module_handle;
		else if ( ::strcmp(procname, "GetProcAddress")   == 0 ) return (FARPROC)::exerb_hook_get_proc_address;
	}

	return ::GetProcAddress(module, procname);
}

////////////////////////////////////////////////////////////////////////////////
