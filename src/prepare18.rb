#!/usr/bin/evn ruby
# $Id: prepare18.rb,v 1.4 2007/06/17 14:47:11 arton Exp $
=begin
  - libexerb/libexerb.dsp 内の出力ファイル名を更新
  - ruby18c, ruby18crt, ruby18g, ruby18grt 内の出力ファイル名を更新
  - ../lib/exerb/config.rb 内の入力ファイル名を更新
=end
require 'fileutils'

if ARGV.length == 0 || !(/\d\d/ =~ ARGV[0])
  STDERR.puts 'usage: ruby prepare18.rb ?? (?? --- exerb??.dll)'
  exit 1
end

/(\d).(\d).(\d)/ =~ RUBY_VERSION
VER = $1 + $2 + $3
puts "version=#{VER}, release=#{ARGV[0]}"

PROJECT = [
           'ruby18c/ruby18c.dsp',
           'ruby18crt/ruby18crt.dsp',
           'ruby18g/ruby18g.dsp',
           'ruby18grt/ruby18grt.dsp',
           '../lib/exerb/config.rb',
           '../test/testcase.rb',
]

class Dsp
  def initialize(name, version, regex)
    @name = name
    @version = version
    @regex = regex
    @file_name = "tmp.#{Process.pid}"
    @file = File.open(@file_name, 'w')
  end

  def write
    f = File.open(@name, 'r')
    f.each_line do |line|
      if @regex =~ line
        line.gsub!($1, @version)
      end
      @file.puts line
    end
    f.close
  end

  def close
    internal_close
    FileUtils.cp(@name, "#{@name}.bak")
    FileUtils.mv(@file_name, @name)
  end

  def discard
    internal_close
    FileUtils.rm_f(@file_name)
  end

  def internal_close
    begin
      @file.close
    rescue
    end
  end

end

class ExcDsp < Dsp
  def initialize(name, target = VER[2..2], regex = Regexp.new("ruby#{VER[0..1]}(\\d)\\w+.exc"))
    super
  end
end

exerb = Dsp.new('libexerb/libexerb.dsp', ARGV[0], /exerb(\d\d)\.dll/)
begin
  exerb.write
  exerb.close
rescue
  STDERR.puts $!.message
  exerb.discard
  exit 2
end

PROJECT.each do |file|
  exc = ExcDsp.new(file)
  begin
    exc.write
    exc.close
  rescue
    STDERR.puts $!.message
    exc.discard
    exit 3
  end
end

