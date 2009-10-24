
#==============================================================================#
# $Id: testcase.rb,v 1.23 2008/06/13 23:53:34 arton Exp $
#==============================================================================#

require 'test/unit/testcase'
require 'exerb/recipe'
require 'exerb/executable'

#==============================================================================#

module ExerbTestCase

  def setup
    @name = self.name
    self.setup_exe
  end

  def setup_exe
    create_exe(@name)
  end

  def name
    raise(NotImplementedError)
  end

  def create_exe(name, exename = name)
    corefile   = '../data/exerb/ruby187c.exc'
    recipe     = Exerb::Recipe.load("#{name}/#{exename}.exy")
    archive    = recipe.create_archive()
    executable = Exerb::Executable.read(corefile)
    executable.rsrc.add_archive(archive)
    executable.write("#{name}/#{exename}.exe")
  end

  def execute_cmd(cmd)
    return `#{cmd}`.gsub(/\r\n/, "\n")
  end

  def execute_exe(name, argv = '')
    return execute_cmd("#{name}/#{name}.exe #{argv}")
  end

  def read_file(filepath)
    return File.open(filepath) { |file| file.read }.gsub(/\r\n/) {"\n"}
  end

  def read_result(name)
    return read_file("#{name}/#{name}.ret")
  end

end # ExerbTestCase

#==============================================================================#
#==============================================================================#
