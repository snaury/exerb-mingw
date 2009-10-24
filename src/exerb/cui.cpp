// $Id: cui.cpp,v 1.10 2005/04/18 14:40:32 yuya Exp $

#include <ruby.h>

////////////////////////////////////////////////////////////////////////////////

int exerb_main(int argc, char** argv, void (*on_init)(VALUE, VALUE, VALUE), void (*on_fail)(VALUE)); // exerb.cpp

int main(int argc, char** argv);
static void on_fail(VALUE errinfo);

////////////////////////////////////////////////////////////////////////////////

int
main(int argc, char** argv)
{
#ifdef _DEBUG
	__asm { int 3 }
#endif
	return ::exerb_main(argc, argv, NULL, on_fail);
}

static void
on_fail(VALUE errinfo)
{
	const VALUE message    = ::rb_funcall(errinfo, ::rb_intern("message"), 0);
	const VALUE backtrace  = ::rb_funcall(errinfo, ::rb_intern("backtrace"), 0);
	const VALUE backtrace1 = ::rb_ary_shift(backtrace);
	const VALUE backtrace2 = ::rb_str_concat(::rb_str_new2("\tfrom "), ::rb_ary_join(backtrace, ::rb_str_new2("\n\tfrom ")));

	::fprintf(stderr, "%s: %s (%s)\n", STR2CSTR(backtrace1), STR2CSTR(message), ::rb_obj_classname(errinfo));
	if ( FIX2INT(::rb_funcall(backtrace, ::rb_intern("size"), 0)) > 0 ) {
		::fprintf(stderr, "%s\n", STR2CSTR(backtrace2));
	}
}

////////////////////////////////////////////////////////////////////////////////
