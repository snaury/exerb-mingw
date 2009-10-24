#!/usr/local/bin/ruby -Ks
# $Id: cpruby18.rb,v 1.1 2007/06/17 14:06:32 arton Exp $
=begin
  -libruby18内のソースファイルを更新
=end

require 'fileutils'

if ARGV.length == 0
  STDERR.puts 'usage: ruby cpruby18.rb ruby-1.8.6-src-directory'
  exit 1
end

unless File.exist?('./libruby18/src')
  STDERR.puts 'must change directory into exerb/src'
  exit 1
end

def rm_and_cp(src, dst, excep = [])
  FileUtils.rm Dir.glob("#{dst}/*.c")
  FileUtils.rm Dir.glob("#{dst}/*.h")
  Dir.open(src).each do |x|
    next unless x =~ /\.c$/i || x =~ /\.h$/i
    next if excep.any? {|e| x =~ e }
    FileUtils.cp("#{src}/#{x}", "#{dst}")
  end
end

rm_and_cp(ARGV[0], 'libruby18/src', [/main.c/i])
rm_and_cp("#{ARGV[0]}/win32", 'libruby18/src/win32', [/winmain.c/i])
rm_and_cp("#{ARGV[0]}/missing", 'libruby18/src/missing')
FileUtils.cp('libruby18/src/win32/config.h', 'libruby18/src')

File.open('libruby18/src/eval_exerb.c', 'w') do |dst|
  File.open('libruby18/src/eval.c', 'r').each_line do |i|
# change require
#    return rb_require_safe(fname, ruby_safe_level);
#    return exerb_require(fname);

    m = /\A(\s*return\s*)(rb_require_safe)([^,]+).+\Z/.match(i)
    if m
      dst.puts "#{m[1]}exerb_require#{m[3]});"
    else
      dst.puts i
    end
  end
end
