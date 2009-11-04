require 'rbconfig'
require 'ostruct'
require 'rake/clean'

SUPPORTED_VERSIONS = {
  "1.8.6" => 383,
  "1.8.7" => 174,
  #"1.9.1" => 243,
}

NEEDS_PATCHING = {
  "1.8.6" => [], #["eval.c", "variable.c"],
  "1.8.7" => [], #["eval.c", "variable.c"],
  #"1.9.1" => ["encoding.c", "load.c", "variable.c"],
}

EXERB_CFLAGS = {
  #"1.9.1" => "-DRUBY19",
}

RUBY_SRC_DIR = nil
RUBY_SRC_MISSING = {
  "1.8.6" => ["fileblocks.c", "crypt.c", "flock.c"],
  "1.8.7" => ["fileblocks.c", "crypt.c", "flock.c"],
  #"1.9.1" => ["langinfo.c", "fileblocks.c", "crypt.c", "flock.c", "lgamma_r.c", "strlcpy.c", "strlcat.c"],
}
RUBY_SRC_IGNORE = [
  # 1.8
  "main.c",
  "winmain.c",
  "lex.c",
  "dmydln.c",
  # 1.9
  "blockinlining.c",
  "dmyencoding.c",
  "eval_error.c",
  "eval_jump.c",
  "golf_prelude.c",
  "goruby.c",
  "id.c",
  "miniprelude.c",
  "thread_pthread.c",
  "thread_win32.c",
  "vm_eval.c",
  "vm_exec.c",
  "vm_insnhelper.c",
  "vm_method.c",
]

C = OpenStruct.new
c = RbConfig::CONFIG
C.cc = "#{c['CC'] || 'gcc'}"
C.cflags = "#{c['CFLAGS'] || '-Os'}"
C.xcflags = "#{c['XCFLAGS'] || '-DRUBY_EXPORT'}"
C.exerb_cflags = "#{EXERB_CFLAGS[RUBY_VERSION]}"
C.cppflags = "#{c['CPPFLAGS']}"
C.incflags = "-Isrc/mingw"
if c['rubyhdrdir']
  C.incflags = "#{C.incflags} -I#{c['rubyhdrdir']}/#{c['arch']} -I#{c['rubyhdrdir']}" if c['rubyhdrdir']
else
  C.incflags = "#{C.incflags} -I#{c['archdir']}"
end
C.ldflags = "-L#{c['libdir']}"
C.xldflags = "#{c['XLDFLAGS'] || '-Wl,--stack,0x02000000'}"
C.rubylib = "#{c['LIBRUBYARG_STATIC']}"
C.libs = "#{c['LIBS']} -lstdc++"
C.ver = RUBY_VERSION.gsub('.','')
C.src_dir = "src/mingw#{C.ver}"

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
  cflags = "#{C.cflags} #{C.xcflags} #{C.exerb_cflags} #{C.cppflags} #{C.incflags}"
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

# Ruby 1.9.1 doesn't have SyncEnumerator
# This function is inspired by Python's zip
def zip(*enums)
  r = block_given? ? nil : []
  len = enums.collect { |x| x.size }.max
  len.times do |i|
    val = enums.collect { |x| x[i] }
    if block_given?
      yield val
    else
      r << val
    end
  end
  r
end

exerb_dll_base        = "exerb50"
file_resource_rc      = "src/exerb/resource.rc"
file_resource_dll_o   = "tmp/resource_dll.o"
file_resource_cui_o   = "tmp/resource_cui.o"
file_resource_gui_o   = "tmp/resource_gui.o"
file_exerb_def        = "tmp/#{exerb_dll_base}.def"
file_exerb_lib        = "tmp/#{exerb_dll_base}.dll.a"
file_exerb_rt_def     = "tmp/#{exerb_dll_base}_rt.def"
file_exerb_dll        = "data/exerb/#{exerb_dll_base}.dll"
file_ruby_cui         = "data/exerb/ruby#{C.ver}c.exc"
file_ruby_cui_rt      = "data/exerb/ruby#{C.ver}crt.exc"
file_ruby_gui         = "data/exerb/ruby#{C.ver}g.exc"
file_ruby_gui_rt      = "data/exerb/ruby#{C.ver}grt.exc"

C.patchlevel = SUPPORTED_VERSIONS[RUBY_VERSION]
C.needs_patching = NEEDS_PATCHING[RUBY_VERSION]
unless C.patchlevel and C.needs_patching
  fail <<-END
Ruby #{RUBY_VERSION} is not yet supported.
Try copying relevant files from ruby source tarball to #{C.src_dir}
and update NEEDS_PATCHING and SUPPORTED_VERSIONS at the top of this
Rakefile.
  END
end

ruby_src              = []
ruby_lib              = nil

if RUBY_SRC_DIR
  C.cflags = "-Os" # optimize for size
  C.rubylib = ""
  C.src_dir = RUBY_SRC_DIR
  files = Dir["#{RUBY_SRC_DIR}/*.c"] + Dir["#{RUBY_SRC_DIR}/win32/*.c"]
  files.each do |filename|
    name = File.basename(filename).downcase
    next if RUBY_SRC_IGNORE.include? name
    next if C.needs_patching.include? name
    ruby_src << filename
  end
  if RUBY_SRC_MISSING[RUBY_VERSION]
    RUBY_SRC_MISSING[RUBY_VERSION].each do |name|
      ruby_src << "#{RUBY_SRC_DIR}/missing/#{name}"
    end
  end
  # TODO: ruby 1.9 requires builtin encodings + prelude.c
  ruby_lib = "tmp/libruby#{C.ver}.a"
else
  unless C.patchlevel == RUBY_PATCHLEVEL
    fail <<-END
Ruby #{RUBY_VERSION}-p#{C.patchlevel} expected, but you are running #{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}.
Try updating relevant files in #{C.src_dir} from ruby source tarball
and update SUPPORTED_VERSIONS at the top of this Rakefile.
    END
  end
end
C.incflags = "#{C.incflags} -I#{C.src_dir}"

ruby_src_unpatched = C.needs_patching.map { |name| "#{C.src_dir}/#{name}" }
ruby_src_patched = ruby_src_unpatched.map { |name| "tmp/patched/#{File.basename(name)}" }
ruby_src += ruby_src_patched
ruby_obj = ruby_src.map { |name| "tmp/#{File.basename(name).gsub(/\.c\Z/i, '.o')}" }

lib_sources = Dir["src/exerb/{exerb,module,utility}.cpp"] + ["src/exerb/vpak.c"] + (ruby_lib ? [ruby_lib] : ruby_obj)
dll_sources = [file_resource_dll_o]
cui_sources = ["src/exerb/cui.cpp", file_resource_cui_o]
gui_sources = ["src/exerb/gui.cpp", file_resource_gui_o]

zip(ruby_src_patched, ruby_src_unpatched) do |target, source|
  patch_rb_require target, source
end

zip(ruby_obj, ruby_src) do |target, source|
  compile_c target, source
end

if ruby_lib
  make_archive ruby_lib, ruby_obj
end

make_resource file_resource_dll_o, file_resource_rc, "RUNTIME"
link_cpp file_exerb_dll, :sources => (dll_sources + lib_sources), :isdll => true, :def => file_exerb_def, :implib => file_exerb_lib
make_def_proxy file_exerb_rt_def, file_exerb_def, exerb_dll_base

make_resource file_resource_cui_o, file_resource_rc, "CUI"
link_cpp file_ruby_cui, :sources => (cui_sources + lib_sources + [file_exerb_def])
link_cpp file_ruby_cui_rt, :sources => (cui_sources + [file_exerb_lib, file_exerb_rt_def]), :rubylib => ""

make_resource file_resource_gui_o, file_resource_rc, "GUI"
link_cpp file_ruby_gui, :sources => (gui_sources + lib_sources + [file_exerb_def]), :gui => true
link_cpp file_ruby_gui_rt, :sources => (gui_sources + [file_exerb_lib, file_exerb_rt_def]), :rubylib => "", :gui => true

task :default => file_ruby_cui
task :default => file_ruby_cui_rt
task :default => file_ruby_gui
task :default => file_ruby_gui_rt

CLEAN.include('tmp')
CLOBBER.include('data')