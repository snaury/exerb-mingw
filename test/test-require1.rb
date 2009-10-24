
#==============================================================================#
# $Id: test-require1.rb,v 1.2 2005/04/15 09:42:52 yuya Exp $
#==============================================================================#

require 'testcase'

#==============================================================================#

class Require1TestCase < Test::Unit::TestCase
  include ExerbTestCase

  def name
    return 'test-require1'
  end

  def test_require
    ret1 = read_result(@name)
    ret2 = execute_exe(@name)
    assert_equal(ret1, ret2)
  end

end # Require1TestCase

#==============================================================================#
#==============================================================================#
