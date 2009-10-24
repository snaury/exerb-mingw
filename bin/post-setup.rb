
#==============================================================================#
# $Id: post-setup.rb,v 1.1 2006/04/27 01:25:21 yuya Exp $
#==============================================================================#

if /mswin32/ =~ RUBY_PLATFORM
  File.open("exerb.bat", "w") { |file|
    file.puts(%|@echo off|)
    file.puts(%|"%~dp0ruby" -x "%~f0" %*|)
    file.puts(%|goto endofruby|)
    file.write(File.read("exerb"))
    file.puts(%|__END__|)
    file.puts(%|:endofruby|)
  }
  File.open("mkexy.bat", "w") { |file|
    file.puts(%|@echo off|)
    file.puts(%|"%~dp0ruby" -x "%~f0" %*|)
    file.puts(%|goto endofruby|)
    file.write(File.read("mkexy"))
    file.puts(%|__END__|)
    file.puts(%|:endofruby|)
  }
end

#==============================================================================#
#==============================================================================#
