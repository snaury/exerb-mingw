require 'rbconfig'
require 'ostruct'
require 'generator'

RUBY_SRC_DIR = nil
C = OpenStruct.new
c = RbConfig::CONFIG
C.cc = "#{c['CC'] || 'gcc'}"
C.cflags = "#{c['CFLAGS'] || '-Os'}"
C.xcflags = "#{c['XCFLAGS'] || '-DRUBY_EXPORT'}"
C.cppflags = "#{c['CPPFLAGS']}"
C.incflags = "-Isrc/mingw -I#{c['archdir']}"
C.ldflags = "-L#{c['libdir']}"
C.xldflags = "#{c['XLDFLAGS'] || '-Wl,--stack,0x02000000'}"
C.rubylib = "#{c['LIBRUBYARG_STATIC']}"
C.libs = "#{c['LIBS']} -lstdc++"

def make_resource(target, source, type)
  file target => source do
    mkdir_p File.dirname(target)
    sh "windres -D#{type} #{source} #{target}"
  end
end

def patch_rb_require(target, source)
  file target => source do
    mkdir_p File.dirname(target)
    File.open(target, 'w') do |dst|
      File.open(source, 'r').each_line do |i|
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
  end
end

def compile_c(target, source)
  cmdline = "#{C.cc} #{C.cflags} #{C.xcflags} #{C.cppflags} #{C.incflags} -c -o #{target} #{source}"
  file target => source do
    mkdir_p File.dirname(target)
    sh cmdline
  end
end

def make_archive(target, sources)
  file target => sources do
    mkdir_p File.dirname(target)
    rm_f target
    sources.each do |source|
      sh "ar q #{target} #{source}"
    end
  end
end

def link_cpp(target, options)
  sources = options[:sources]
  cc = C.cc
  cflags = "#{C.cflags} #{C.xcflags} #{C.cppflags} #{C.incflags}"
  ldflags = "#{C.ldflags} #{C.xldflags}"
  dllflags = options[:isdll] ? "-shared" : ""
  guiflags = options[:gui] ? "-mwindows" : ""
  dldflags = options[:isdll] ? "-Wl,--enable-auto-image-base,--enable-auto-import,--export-all" : ""
  impflags = options[:implib] ? "-Wl,--out-implib=#{options[:implib]}" : ""
  defflags = options[:def] ? "-Wl,--output-def=#{options[:def]}" : ""
  rubylib = (options[:rubylib] || C.rubylib)
  libs = C.libs
  cmdline = "#{cc} #{cflags} #{ldflags} #{dllflags} #{guiflags} #{dldflags} #{impflags} #{defflags} -s -o #{target} #{sources.join(' ')} #{rubylib} #{libs}"
  file target => sources do
    mkdir_p File.dirname(options[:implib]) if options[:implib]
    mkdir_p File.dirname(options[:def]) if options[:def]
    mkdir_p File.dirname(target)
    sh cmdline
    sh "strip -R .reloc #{target}" unless options[:isdll]
  end
  file options[:implib] => target if options[:implib]
  file options[:def] => target if options[:def]
end

def make_def_proxy(target, source, proxy)
  file target => source do
    mkdir_p File.dirname(target)
    File.open(target, "w") do |out|
      File.open(source, "r").each_line do |line|
        case line
        when /\A\s*(LIBRARY|EXPORTS)/
          out.puts line
        when /\A(\s*)(\w+)(\s+@.*)\Z/
          out.puts "#{$1}#{$2} = #{proxy}.#{$2}#{$3}"
        else
          out.puts line
        end
      end
    end
  end
end

ver = RUBY_VERSION.gsub('.','')
exerb_dll_base = "exerb50"

file_resource_dll_o   = "tmp/resource_dll.o"
file_resource_cui_o   = "tmp/resource_cui.o"
file_resource_gui_o   = "tmp/resource_gui.o"
file_exerb_def        = "tmp/#{exerb_dll_base}.def"
file_exerb_lib        = "tmp/#{exerb_dll_base}.dll.a"
file_exerb_rt_def     = "tmp/#{exerb_dll_base}_rt.def"
file_exerb_dll        = "data/exerb/#{exerb_dll_base}.dll"
file_ruby_cui         = "data/exerb/ruby#{ver}c.exc"
file_ruby_cui_rt      = "data/exerb/ruby#{ver}crt.exc"
file_ruby_gui         = "data/exerb/ruby#{ver}g.exc"
file_ruby_gui_rt      = "data/exerb/ruby#{ver}grt.exc"
file_eval_c           = "src/mingw#{ver}/eval.c"
file_eval_exerb_c     = "tmp/eval_exerb.c"
file_eval_exerb_o     = "tmp/eval_exerb.o"
file_variable_c       = "src/mingw#{ver}/variable.c"
file_variable_exerb_c = "tmp/variable_exerb.c"
file_variable_exerb_o = "tmp/variable_exerb.o"
ruby_src              = [file_eval_exerb_c, file_variable_exerb_c]
ruby_obj              = [file_eval_exerb_o, file_variable_exerb_o]
ruby_lib              = nil

if RUBY_SRC_DIR
  C.cflags = "-Os" # optimize for size
  C.incflags = "#{C.incflags} -I#{RUBY_SRC_DIR}"
  C.rubylib = ""
  file_eval_c = "#{RUBY_SRC_DIR}/eval.c"
  file_variable_c = "#{RUBY_SRC_DIR}/variable.c"
  ruby_src = []
  Dir["#{RUBY_SRC_DIR}/*.c"].each do |filename|
    next if filename =~ /lex\.c/i
    next if filename =~ /eval\.c/i
    next if filename =~ /main\.c/i
    next if filename =~ /variable\.c/i
    ruby_src << filename
  end
  Dir["#{RUBY_SRC_DIR}/win32/*.c"].each do |filename|
    next if filename =~ /winmain\.c/i
    ruby_src << filename
  end
  ["fileblocks.c", "crypt.c", "flock.c"].each do |name|
    ruby_src << "#{RUBY_SRC_DIR}/missing/#{name}"
  end
  ruby_src << file_eval_exerb_c
  ruby_src << file_variable_exerb_c
  ruby_obj = ruby_src.map { |filename| filename.sub(RUBY_SRC_DIR, 'tmp').gsub(/\.c\Z/i, '.o') }
  ruby_lib = "tmp/libruby#{ver}.a"
  make_archive ruby_lib, ruby_obj
end

lib_sources = Dir["src/exerb/{exerb,module,utility}.cpp"] + (ruby_lib ? [ruby_lib] : ruby_obj)
dll_sources = [file_resource_dll_o]
cui_sources = ["src/exerb/cui.cpp", file_resource_cui_o]
gui_sources = ["src/exerb/gui.cpp", file_resource_gui_o]

patch_rb_require file_eval_exerb_c, file_eval_c
patch_rb_require file_variable_exerb_c, file_variable_c
SyncEnumerator.new(ruby_obj, ruby_src).each do |target, source|
  compile_c target, source
end

make_resource file_resource_dll_o, "src/exerb/resource.rc", "RUNTIME"
link_cpp file_exerb_dll, :sources => (dll_sources + lib_sources), :isdll => true, :def => file_exerb_def, :implib => file_exerb_lib
make_def_proxy file_exerb_rt_def, file_exerb_def, exerb_dll_base

make_resource file_resource_cui_o, "src/exerb/resource.rc", "CUI"
link_cpp file_ruby_cui, :sources => (cui_sources + lib_sources + [file_exerb_def])
link_cpp file_ruby_cui_rt, :sources => (cui_sources + [file_exerb_lib, file_exerb_rt_def]), :rubylib => ""

make_resource file_resource_gui_o, "src/exerb/resource.rc", "GUI"
link_cpp file_ruby_gui, :sources => (gui_sources + lib_sources + [file_exerb_def]), :gui => true
link_cpp file_ruby_gui_rt, :sources => (gui_sources + [file_exerb_lib, file_exerb_rt_def]), :rubylib => "", :gui => true

task :default => file_ruby_cui
task :default => file_ruby_cui_rt
task :default => file_ruby_gui
task :default => file_ruby_gui_rt
