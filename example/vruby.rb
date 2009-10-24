
#==============================================================================#
# $Id: vruby.rb,v 1.1 2006/07/06 01:35:22 yuya Exp $
#==============================================================================#

require 'vr/vruby'
require 'vr/vrcontrol'

#==============================================================================#

class MyForm < VRForm

  def construct
    self.caption = 'Example'
    self.move(100, 100, 150, 160)
    self.addControl(VRButton, 'cmd_exit',  'Exit',      20, 20, 100, 40)
    self.addControl(VRButton, 'cmd_raise', 'Exception', 20, 70, 100, 40)
  end

  def cmd_exit_clicked
    messageBox('exit', 'Example', 0)
    exit
  end

  def cmd_raise_clicked
    messageBox('raising an exception from now.', 'Example', 0)
    raise('This is an exception.')
  end

end

#==============================================================================#

VRLocalScreen.showForm(MyForm)
VRLocalScreen.messageloop

#==============================================================================#
#==============================================================================#
