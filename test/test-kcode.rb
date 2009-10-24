
#==============================================================================#
# $Id: test-kcode.rb,v 1.6 2005/04/15 09:42:52 yuya Exp $
#==============================================================================#

require 'testcase'

#==============================================================================#

class KcodeTestCase < Test::Unit::TestCase
  include ExerbTestCase

  def name
    return 'test-kcode'
  end

  def setup_exe
    create_exe(@name, 'none')
    create_exe(@name, 'euc')
    create_exe(@name, 'sjis')
    create_exe(@name, 'utf8')
  end

  def test_none
    assert_equal(read_file("#{@name}/none.ret"), execute_cmd("#{@name}/none.exe"))
  end

  def test_euc
    assert_equal(read_file("#{@name}/euc.ret"), execute_cmd("#{@name}/euc.exe"))
  end

  def test_sjis
    assert_equal(read_file("#{@name}/sjis.ret"), execute_cmd("#{@name}/sjis.exe"))
  end

  def test_utf8
    assert_equal(read_file("#{@name}/utf8.ret"), execute_cmd("#{@name}/utf8.exe"))
  end

end # KcodeTestCase

#==============================================================================#
#==============================================================================#
