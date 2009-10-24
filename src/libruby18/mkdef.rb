#!/usr/bin/env ruby
# $Id: mkdef.rb,v 1.11 2009/09/07 18:18:49 arton Exp $
require 'fileutils'

EXERB_NAME = 'exerb50'
EXERB_SYMBOLS = [
                 '',
                 'rb_mExerbRuntime',
                 'rb_eExerbRuntimeError',
                 '',
                 'exerb_main',
]

if ARGV.length == 0
  STDERR.puts 'usage: pathname_of_msvcrt-ruby18.def'
  exit 1
end

class Deffile
  def initialize
    @standalone_name = "tmp.#{Process.pid}-1"
    @runtime_name = "tmp.#{Process.pid}-2"
    @standalone = File.open(@standalone_name, 'w')
    @runtime = File.open(@runtime_name, 'w')
  end

  def puts(line)
    if /^\s*;\s*$/ =~ line
    elsif /^EXPORTS\s*$/ =~ line
      internal_puts line
    elsif /^\s*([A-Za-z0-9_]+)(\s+DATA)?\s*$/ =~ line
      internal_puts $1, "#{$1} = #{EXERB_NAME}.#{$1}"
    else
      internal_puts line
    end
  end

  def close
    internal_close
    FileUtils.mv(@standalone_name, 'libruby18_standalone.def')
    FileUtils.mv(@runtime_name, 'libruby18_runtime.def')
  end

  def discard
    internal_close
    FileUtils.rm_f(@runtime_name)
    FileUtils.rm_f(@standalone_name)
  end

  def internal_puts(line, line2 = nil)
    @standalone.puts line
    @runtime.puts((line2) ? line2 : line)
  end

  def internal_close
    begin
      @standalone.close
      @runtime.close
    rescue
    end
  end
end

deff = Deffile.new
begin
  File.open(ARGV[0], 'r').each_line do |line|
    deff.puts line
  end
  EXERB_SYMBOLS.each do |line|
    deff.puts line
  end
  deff.close
rescue
  deff.discard
end
