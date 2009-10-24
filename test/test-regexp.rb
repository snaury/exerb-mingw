
#==============================================================================#
# $Id: test-regexp.rb,v 1.5 2005/04/15 09:42:52 yuya Exp $
#==============================================================================#

require 'testcase'

#==============================================================================#

class RegexpTestCase < Test::Unit::TestCase
  include ExerbTestCase

  def name
    return 'test-regexp'
  end

  def test_regexp
    ret1 = read_result(@name)
    ret2 = execute_exe(@name)
    assert_equal(ret1, ret2)
  end

end # RegexpTestCase

#==============================================================================#
#==============================================================================#
