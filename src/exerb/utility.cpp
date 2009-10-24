// $Id: utility.cpp,v 1.20 2006/05/09 01:10:49 yuya Exp $

#include <ruby.h>
#include "exerb.h"
#include "utility.h"

////////////////////////////////////////////////////////////////////////////////

extern VALUE rb_eExerbRuntimeError;

extern NAME_TABLE_HEADER *g_name_table_header;
extern FILE_TABLE_HEADER *g_file_table_header;

////////////////////////////////////////////////////////////////////////////////

char*
exerb_strdup(const char* str)
{
	if ( str == NULL ) return NULL;

	char *newstr = new char[::strlen(str) + 1];
	::strcpy(newstr, str);

	return newstr;
}

HANDLE
exerb_fopen_for_read(const char *filepath)
{
	HANDLE file = ::CreateFile(filepath, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, NULL, NULL);
	if ( file == INVALID_HANDLE_VALUE ) ::exerb_raise_runtime_error(::GetLastError());

	return file;
}

HANDLE
exerb_fopen_for_write(const char *filepath)
{
	HANDLE file = ::CreateFile(filepath, GENERIC_WRITE, FILE_SHARE_READ, NULL, CREATE_ALWAYS, NULL, NULL);
	if ( file == INVALID_HANDLE_VALUE ) ::exerb_raise_runtime_error(::GetLastError());

	return file;
}

BOOL
exerb_fclose(const HANDLE file)
{
	BOOL ret = ::CloseHandle(file);
	if ( !ret ) ::exerb_raise_runtime_error(::GetLastError());

	return ret;
}

DWORD
exerb_fseek(const HANDLE file, const LONG pos, const DWORD method)
{
	DWORD ret = ::SetFilePointer(file, pos, NULL, method);
	//if ( ret == INVALID_SET_FILE_POINTER ) ::exerb_raise_runtime_error(::GetLastError())

	return ret;
}

DWORD
exerb_fread(const HANDLE file, void *buffer, const int size)
{
	DWORD read_size = 0;
	BOOL  ret = ::ReadFile(file, buffer, size, &read_size, NULL);
	if ( !ret ) {
		DWORD error = ::GetLastError();
		::CloseHandle(file);
		::exerb_raise_runtime_error(error);
	}

	return read_size;
}

DWORD
exerb_fwrite(const HANDLE file, const void *buffer, const int size)
{
	DWORD written = 0;
	BOOL ret = ::WriteFile(file, buffer, size, &written, NULL);
	if ( !ret ) {
		DWORD error = ::GetLastError();
		::CloseHandle(file);
		::exerb_raise_runtime_error(error);
	}

	return written;
}

DWORD
exerb_fsize(const HANDLE file)
{
	DWORD size = ::GetFileSize(file, NULL);
	if ( size == (DWORD)-1 ) {
		DWORD error = ::GetLastError();
		::CloseHandle(file);
		::exerb_raise_runtime_error(error);
	}

	return size;
}

const char*
exerb_get_module_filepath(const HMODULE handle, char *filepath, int size)
{
	const DWORD ret = ::GetModuleFileName(handle, filepath, size);
	if ( !ret ) ::exerb_raise_runtime_error(::GetLastError());

	return ::exerb_get_filename(filepath);
}

const char*
exerb_get_self_filepath(char *filepath, const int size)
{
	return ::exerb_get_module_filepath(NULL, filepath, size);
}

const char*
exerb_get_filename(const char *filepath)
{
	char *filename = NULL;
	if ( filename = ::strrchr(filepath, '\\') ) return filename + 1;
	if ( filename = ::strrchr(filepath, '/')  ) return filename + 1;

	return filepath;
}

bool
exerb_cmp_filename_with_ext(const char *name1, const char *name2, const char *ext)
{
	const int name2len = ::strlen(name2);
	return (::strnicmp(name1, name2, name2len) == 0 && name1[name2len] == '.' && ::stricmp(name1 + name2len + 1, ext) == 0);
}

void
exerb_create_tmpfile(const char *prefix, char *filepath, const void *buffer, const int size)
{
	char tmp_dirpath[MAX_PATH]  = "";
	::GetTempPath(sizeof(tmp_dirpath), tmp_dirpath);
	::GetTempFileName(tmp_dirpath, prefix, 0, filepath);

	HANDLE file = ::exerb_fopen_for_write(filepath);
	::exerb_fwrite(file, buffer, size);
	::exerb_fclose(file);
}

void
exerb_raise_runtime_error(const DWORD error_no)
{
	char message0[1024] = "";
	char message1[1024 + 128] = "";
	::FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, NULL, error_no, MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), message0, sizeof(message0), NULL);
	::_snprintf(message1, sizeof(message1), "Win32API Error #%i --- %s", error_no, message0);
	::rb_raise(rb_eExerbRuntimeError, message1);
}

NAME_ENTRY_HEADER*
exerb_get_first_name_entry()
{
	return (NAME_ENTRY_HEADER*)((DWORD)g_name_table_header + g_name_table_header->offset_of_headers);
}

FILE_ENTRY_HEADER*
exerb_get_first_file_entry()
{
	return (FILE_ENTRY_HEADER*)((DWORD)g_file_table_header + g_file_table_header->offset_of_headers);
}

char*
exerb_get_name_from_entry(const NAME_ENTRY_HEADER *name_entry)
{
	return (char*)((DWORD)g_name_table_header + g_name_table_header->offset_of_pool + name_entry->offset_of_name);
}

char*
exerb_get_file_from_entry(const FILE_ENTRY_HEADER *file_entry)
{
	return (char*)((DWORD)g_file_table_header + g_file_table_header->offset_of_pool + file_entry->offset_of_file);
}

NAME_ENTRY_HEADER*
exerb_find_name_entry(const WORD id)
{
	NAME_ENTRY_HEADER *name_entry = ::exerb_get_first_name_entry();

	for ( int i = 0; i < g_name_table_header->number_of_headers; i++, name_entry++ ) {
		if ( name_entry->id == id ) {
			return name_entry;
		}
	}

	::rb_raise(rb_eExerbRuntimeError, "Couldn't find a name entry --- %i", id);

	return NULL;
}

NAME_ENTRY_HEADER*
exerb_find_name_entry(const char *filename, const char *ext)
{
	{
		NAME_ENTRY_HEADER *name_entry = ::exerb_get_first_name_entry();

		for ( int i = 0; i < g_name_table_header->number_of_headers; i++, name_entry++ ) {
			if ( ::stricmp(::exerb_get_name_from_entry(name_entry), filename) == 0 ) {
				return name_entry;
			}
		}
	}

	if ( ext ) {
		NAME_ENTRY_HEADER *name_entry = ::exerb_get_first_name_entry();

		for ( int i = 0; i < g_name_table_header->number_of_headers; i++, name_entry++ ) {
			if ( ::exerb_cmp_filename_with_ext(::exerb_get_name_from_entry(name_entry), filename, ext) ) {
				return name_entry;
			}
		}
	}

	return NULL;
}

FILE_ENTRY_HEADER*
exerb_find_file_entry(const WORD id)
{
	FILE_ENTRY_HEADER *file_entry = ::exerb_get_first_file_entry();

	for ( int i = 0; i < g_file_table_header->number_of_headers; i++, file_entry++ ) {
		if ( file_entry->id == id ) {
			return file_entry;
		}
	}

	::rb_raise(rb_eExerbRuntimeError, "Couldn't find a file entry --- %i", id);

	return NULL;
}

FILE_ENTRY_HEADER*
exerb_find_file_entry(const char *filename, const char *ext)
{
	NAME_ENTRY_HEADER *name_entry = ::exerb_find_name_entry(filename, ext);
	return (name_entry ? ::exerb_find_file_entry(name_entry->id) : NULL);
}

////////////////////////////////////////////////////////////////////////////////
