
#==============================================================================#
# $Id: rubytk.rb,v 1.3 2006/07/06 04:26:40 yuya Exp $
#==============================================================================#

def autoload(mod, fname)
end

TkEvent = Module.new
TkPack  = Module.new
TkWinfo = Module.new

require "tk"
require "tk/event"
require "tk/winfo"
require "tk/button"
require "tk/pack"

#==============================================================================#

TkButton.new(nil, 
             :text => 'hello',
             :command => proc{print "hello\n"}).pack(:fill=>'x')

TkButton.new(nil,
             :text => 'quit',
             :command => proc{exit}).pack(:fill=>'x')

#==============================================================================#

Tk.mainloop

#==============================================================================#
#==============================================================================#
