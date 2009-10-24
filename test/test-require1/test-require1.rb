
#==============================================================================#
# $Id: test-require1.rb,v 1.1 2003/12/04 14:06:59 yuya Exp $
#==============================================================================#

p([File.basename(__FILE__), $"])

p(require('require1'))
p(require('require1.rb'))

p([File.basename(__FILE__), $"])

p(require('require2.rb'))
p(require('require2'))

p([File.basename(__FILE__), $"])

p(require('require3.rb'))
p(require('require3.rb'))

p([File.basename(__FILE__), $"])

p(require('require4'))
p(require('require4'))

p([File.basename(__FILE__), $"])

p(require('require5.rb'))
p(require('require5.rb'))
p(require('require5'))

p([File.basename(__FILE__), $"])

p(require('require6'))
p(require('require6'))
p(require('require6.rb'))

p([File.basename(__FILE__), $"])

#==============================================================================#
#==============================================================================#
