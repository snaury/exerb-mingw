// $Id: module.cpp,v 1.11 2007/02/25 16:44:51 yuya Exp $

#include <ruby.h>
#include "exerb.h"
#include "module.h"
#include "utility.h"

////////////////////////////////////////////////////////////////////////////////

extern VALUE rb_mExerbRuntime;
extern VALUE rb_eExerbRuntimeError;

extern FILE_TABLE_HEADER *g_file_table_header;

extern int     g_loaded_resource_count;
extern HMODULE g_loaded_resource_table[];

////////////////////////////////////////////////////////////////////////////////

static VALUE rb_exerbruntime_s_filepath(VALUE self);
static VALUE rb_exerbruntime_s_filename(VALUE self);
static VALUE rb_exerbruntime_s_open(VALUE self, VALUE filename);
static VALUE rb_exerbruntime_s_load_string(VALUE self, VALUE id);
static VALUE rb_exerbruntime_s_load_icon(VALUE self, VALUE id);
static VALUE rb_exerbruntime_s_load_cursor(VALUE self, VALUE id);
static LPCTSTR exerb_convert_resource_id(VALUE value);

////////////////////////////////////////////////////////////////////////////////

void
Init_ExerbRuntime()
{
	static VALUE gv_exerb = Qtrue;
	::rb_define_readonly_variable("$Exerb", &gv_exerb);

	rb_mExerbRuntime = ::rb_define_module("ExerbRuntime");

	::rb_define_singleton_method(rb_mExerbRuntime, "filepath",    (RUBY_PROC)rb_exerbruntime_s_filepath, 0);
	::rb_define_singleton_method(rb_mExerbRuntime, "filename",    (RUBY_PROC)rb_exerbruntime_s_filename, 0);
	::rb_define_singleton_method(rb_mExerbRuntime, "open",        (RUBY_PROC)rb_exerbruntime_s_open, 1);
	::rb_define_singleton_method(rb_mExerbRuntime, "load_string", (RUBY_PROC)rb_exerbruntime_s_load_string, 1);
	::rb_define_singleton_method(rb_mExerbRuntime, "load_icon",   (RUBY_PROC)rb_exerbruntime_s_load_icon, 1);
	::rb_define_singleton_method(rb_mExerbRuntime, "load_cursor", (RUBY_PROC)rb_exerbruntime_s_load_cursor, 1);

	rb_eExerbRuntimeError = ::rb_define_class_under(rb_mExerbRuntime, "Error", rb_eException);
}

static VALUE
rb_exerbruntime_s_filepath(VALUE self)
{
	char filepath[MAX_PATH] = "";
	::exerb_get_self_filepath(filepath, sizeof(filepath));
	return ::rb_str_new2(filepath);
}

static VALUE
rb_exerbruntime_s_filename(VALUE self)
{
	char filepath[MAX_PATH] = "";
	const char *filename = ::exerb_get_self_filepath(filepath, sizeof(filepath));
	return ::rb_str_new2(filename);
}

static VALUE
rb_exerbruntime_s_open(VALUE self, VALUE filename)
{
	::Check_SafeStr(filename);
	::rb_require("stringio");

	NAME_ENTRY_HEADER *name_entry = ::exerb_find_name_entry(RSTRING_PTR(filename));
	if ( !name_entry ) ::rb_raise(rb_eLoadError, "No such file to load -- %s", RSTRING_PTR(filename));

	FILE_ENTRY_HEADER *file_entry = ::exerb_find_file_entry(name_entry->id);
	VALUE file = ::rb_str_new(::exerb_get_file_from_entry(file_entry), file_entry->size_of_file);

	return ::rb_funcall(::rb_path2class("StringIO"), ::rb_intern("new"), 2, file, ::rb_str_new2("r"));
}

static VALUE
rb_exerbruntime_s_load_string(VALUE self, VALUE id)
{
	LPCSTR res_id = ::exerb_convert_resource_id(id);
	char buffer[512] = "";

	for ( int i = 0; i < g_loaded_resource_count; i++ ) {
		if ( ::LoadString(g_loaded_resource_table[i], (unsigned int)res_id, buffer, sizeof(buffer)) ) {
			return ::rb_str_new2(buffer);
		}
	}

	return Qnil;
}

static VALUE
rb_exerbruntime_s_load_icon(VALUE self, VALUE id)
{
	LPCSTR res_id = ::exerb_convert_resource_id(id);

	for ( int i = 0; i < g_loaded_resource_count; i++ ) {
		HICON icon = ::LoadIcon(g_loaded_resource_table[i], res_id);
		if ( icon ) return INT2NUM((int)icon);
	}

	return Qnil;
}

static VALUE
rb_exerbruntime_s_load_cursor(VALUE self, VALUE id)
{
	LPCSTR res_id = ::exerb_convert_resource_id(id);

	for ( int i = 0; i < g_loaded_resource_count; i++ ) {
		HCURSOR icon = ::LoadCursor(g_loaded_resource_table[i], res_id);
		if ( icon ) return INT2NUM((int)icon);
	}

	return Qnil;
}

static LPCTSTR
exerb_convert_resource_id(VALUE value)
{
	switch ( TYPE(value) ) {
	case T_FIXNUM:
		return MAKEINTRESOURCE(FIX2INT(value));
	case T_STRING:
		return RSTRING_PTR(value);
	default:
		::rb_raise(rb_eArgError, "argument needs to be integer or string");
		return NULL;
	}
}

////////////////////////////////////////////////////////////////////////////////
