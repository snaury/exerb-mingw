
#==============================================================================#
# $Id: Makefile,v 1.5 2006/07/06 01:35:22 yuya Exp $
#==============================================================================#

all: cat_n exception msgbox vruby runtime

#==============================================================================#

EXERB  = exerb -v
REMOVE = rm

#==============================================================================#

cat_n: cat_n.rb cat_n.exy Makefile
	$(EXERB) cat_n.exy

exception: exception.rb exception.exy Makefile
	$(EXERB) exception.exy

msgbox: msgbox.rb msgbox.exy Makefile
	$(EXERB) msgbox.exy

vruby: vruby.rb vruby.exy Makefile
	$(EXERB) vruby.exy

runtime: runtime.rb runtime.exy Makefile
	$(EXERB) runtime.exy

#==============================================================================#

clean:
	-$(REMOVE) cat_n.exe
	-$(REMOVE) exception.exe
	-$(REMOVE) msgbox.exe
	-$(REMOVE) vruby.exe
	-$(REMOVE) runtime.exe

#==============================================================================#
#==============================================================================#
