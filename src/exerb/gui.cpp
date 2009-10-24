// $Id: gui.cpp,v 1.14 2007/02/25 16:44:51 yuya Exp $

#include <ruby.h>
#include <windowsx.h>
#include "exerb.h"
#include "resource.h"

////////////////////////////////////////////////////////////////////////////////

int exerb_main(int argc, char** argv, void (*on_init)(VALUE, VALUE, VALUE), void (*on_fail)(VALUE)); // exerb.cpp

int WINAPI WinMain(HINSTANCE current_instance, HINSTANCE prev_instance, LPSTR cmd_line, int show_cmd);
static void on_init(VALUE io_stdin, VALUE io_stdout, VALUE io_stderr);
static void on_fail(VALUE errinfo);

static void exerb_replace_io_methods(const VALUE io);
static VALUE rb_exerbio_write(VALUE self, VALUE str);
static VALUE rb_exerbio_retrun_nil(int argc, VALUE *argv, VALUE self);

static LRESULT CALLBACK dialog_proc(HWND hwnd, UINT message, WPARAM wparam, LPARAM lparam);

////////////////////////////////////////////////////////////////////////////////

int WINAPI
WinMain(HINSTANCE current_instance, HINSTANCE prev_instance, LPSTR cmd_line, int show_cmd)
{
#ifdef _DEBUG
	__asm { int 3 }
#endif
	return ::exerb_main(0, NULL, on_init, on_fail);
}

static void
on_init(VALUE io_stdin, VALUE io_stdout, VALUE io_stderr)
{
	::exerb_replace_io_methods(io_stdin);
	::exerb_replace_io_methods(io_stdout);
	::exerb_replace_io_methods(io_stderr);

	::rb_define_global_function("gets", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_global_function("readline", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_global_function("getc", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_global_function("readlines", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
}

static void
on_fail(VALUE errinfo)
{
	::DialogBoxParam(::GetModuleHandle(NULL), MAKEINTRESOURCE(IDD_EXCEPTION), NULL, (DLGPROC)dialog_proc, (LPARAM)errinfo);
}

////////////////////////////////////////////////////////////////////////////////

static void
exerb_replace_io_methods(const VALUE io)
{
	::rb_define_singleton_method(io, "reopen", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_singleton_method(io, "each", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_singleton_method(io, "each_line", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_singleton_method(io, "each_byte", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_singleton_method(io, "syswrite", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_singleton_method(io, "sysread", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_singleton_method(io, "fileno", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_singleton_method(io, "to_i", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_singleton_method(io, "to_io", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_singleton_method(io, "fsync", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_singleton_method(io, "sync", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_singleton_method(io, "sync=", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_singleton_method(io, "lineno", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_singleton_method(io, "lineno=", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_singleton_method(io, "readlines", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_singleton_method(io, "read", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_singleton_method(io, "write", (RUBY_PROC)rb_exerbio_write, 1);
	::rb_define_singleton_method(io, "gets", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_singleton_method(io, "readline", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_singleton_method(io, "getc", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_singleton_method(io, "readchar", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_singleton_method(io, "ungetc", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_singleton_method(io, "flush", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_singleton_method(io, "tell", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_singleton_method(io, "seek", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_singleton_method(io, "rewind", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_singleton_method(io, "pos", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_singleton_method(io, "pos=", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_singleton_method(io, "eof", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_singleton_method(io, "eof?", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_singleton_method(io, "close", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_singleton_method(io, "closed?", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_singleton_method(io, "close_read", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_singleton_method(io, "close_write", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_singleton_method(io, "isatty", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_singleton_method(io, "tty?", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_singleton_method(io, "binmode", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_singleton_method(io, "sysseek", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_singleton_method(io, "ioctl", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_singleton_method(io, "fcntl", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
	::rb_define_singleton_method(io, "pid", (RUBY_PROC)rb_exerbio_retrun_nil, -1);
}

static VALUE
rb_exerbio_write(VALUE self, VALUE str)
{
	::rb_secure(4);
	if ( TYPE(str) != T_STRING ) str = ::rb_obj_as_string(str);
	if ( RSTRING_LEN(str) > 0 ) ::OutputDebugString(RSTRING_PTR(str));
	return Qnil;
}

static VALUE
rb_exerbio_retrun_nil(int argc, VALUE *argv, VALUE self)
{
	return Qnil;
}

////////////////////////////////////////////////////////////////////////////////

static LRESULT CALLBACK
dialog_proc(HWND hwnd, UINT message, WPARAM wparam, LPARAM lparam)
{
	static HFONT font = NULL;

	switch ( message ) {
		case WM_INITDIALOG:
			if ( lparam ) {
				const VALUE errinfo       = (VALUE)lparam;
				const VALUE message       = ::rb_funcall(errinfo, ::rb_intern("message"), 0);
				const VALUE message_str   = ::rb_funcall(message, ::rb_intern("gsub"), 2, ::rb_str_new2("\n"), ::rb_str_new2("\r\n"));
				const VALUE backtrace     = ::rb_funcall(errinfo, ::rb_intern("backtrace"), 0);
				const VALUE backtrace_str = ::rb_str_concat(::rb_ary_join(backtrace, ::rb_str_new2("\r\n")), rb_str_new2("\r\n"));

				::SetDlgItemText(hwnd, IDC_EDIT_TYPE,      ::rb_obj_classname(errinfo));
				::SetDlgItemText(hwnd, IDC_EDIT_MESSAGE,   STR2CSTR(message_str));
				::SetDlgItemText(hwnd, IDC_EDIT_BACKTRACE, STR2CSTR(backtrace_str));
			}

			{
				char self_filename[MAX_PATH]       = "";
				char window_title_format[MAX_PATH] = "";
				char window_title[MAX_PATH]        = "";
				::GetModuleFileName(NULL, self_filename, sizeof(self_filename));
				::GetWindowText(hwnd, window_title_format, sizeof(window_title_format));
				::wsprintf(window_title, window_title_format, self_filename);
				::SetWindowText(hwnd, window_title);
			}

			font = ::CreateFont(14, 0, 0, 0, FW_REGULAR, FALSE, FALSE, FALSE, SHIFTJIS_CHARSET, OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, PROOF_QUALITY, FIXED_PITCH | FF_MODERN, "Terminal");
			SetWindowFont(::GetDlgItem(hwnd, IDC_EDIT_TYPE),      font, false);
			SetWindowFont(::GetDlgItem(hwnd, IDC_EDIT_MESSAGE),   font, false);
			SetWindowFont(::GetDlgItem(hwnd, IDC_EDIT_BACKTRACE), font, false);

			::MessageBeep(MB_ICONHAND);
			
			return TRUE;
		case WM_DESTROY:
			::DeleteObject(font);
			return TRUE;
		case WM_CLOSE:
			::EndDialog(hwnd, ID_CLOSE);
			return TRUE;
		case WM_COMMAND:
			if ( LOWORD(wparam) == ID_CLOSE ) {
				::EndDialog(hwnd, ID_CLOSE);
				return TRUE;
			}
			break;
	}

	return FALSE;
}

////////////////////////////////////////////////////////////////////////////////
