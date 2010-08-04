require 'rake/clean'
require 'rake/testtask' 
require 'fileutils'

CLEAN.include 'lib/**/*.o', 'build'
CLOBBER.include 'pkg', 'ship', 'noyes.gemspec', 'lib/cext/*.bundle'
directory 'ship'

def ensure_dir file
  dir = File.dirname file
  mkdir_p dir unless File.exists? dir
end

def make_jar objs, lang
  jar = "ship/noyes.jar" 
  task :jar => jar
  task :default => :jar
  objtrunc = objs.map {|obj| obj.sub /^build\/#{lang}\//, ''}
  file jar => 'ship' do
    sh "jar -cf #{jar} -C build/#{lang}_impl ."
  end
end

module JavaBuild
  SRC = Dir['lib/java_impl/**/*.java']
  OBJ = SRC.map {|s| s.pathmap "%{^lib,build}X.class"}
  SRC.zip(OBJ).each do |src, obj|
    file obj => src do
      ensure_dir obj
      sh "javac -source 1.5 -Xlint -d build/java_impl #{SRC.join ' '}"
    end
  end
  make_jar OBJ, 'java'
  file 'ship/noyes.jar' => OBJ
end

desc 'Build c extension'
task :cext do
  `cd lib/cext; ruby extconf.rb; make`
end

task :jar => 'ship/noyes.jar'
task :default => :build

module Tags
  FILES = FileList['lib/**/*.rb'] << FileList['lib/**/*.java'] <<
          FileList['lib/**/*.c'] << FileList['lib/**/*.h']
end

task :tags do
    sh "ctags --extra=+q -f .tags #{Tags::FILES}", :verbose => false
end

# Crude portable shell command
def tcmd cmd
  sh cmd.gsub(':', File::PATH_SEPARATOR)
end

# These tests test against the default ruby version, which is assumed to
# be called 'ruby'.  This works great if you use RVM.
desc 'Basic pure Ruby implementation tests.'
task :test do
  tcmd "ruby -Ilib:test test/ts_fast_ruby.rb"
end

namespace :test do
  desc 'Test for memory leaks in C extension version'
  task :memory do
    full_check = '--leak-check=full --show-reachable=yes --track-origins=yes -v'
    vparams = '--tool=memcheck --leak-check=yes --num-callers=15 --track-fds=yes'
    tcmd "valgrind #{vparams} #{full_check} ruby -Ilib:test:ext test/ts_all_c.rb"
  end

  desc 'Full (extreme) Ruby implementation tests.'
  task :full do
    tcmd "ruby -Ilib:test test/ts_all_ruby.rb"
  end
  
  desc 'C-extension tests.'
  task :c => :cext do
    tcmd "ruby -Ilib:test:ext test/ts_all_c.rb"
  end

  desc 'Basic Java implementation test.'
  task :java => :jar do
    tcmd "ruby -Ilib:test:ship test/ts_fast_java.rb"
  end

  namespace :java do
    desc 'Full (extreme) Java extension tests.'
    task :full => :jar do
      tcmd "ruby -Ilib:test:ship test/ts_all_java.rb"
    end
  end
end

namespace :wc do
  desc 'Number of lines, words, and bytes of Java code'
  task :java do
    sh "wc #{Dir['lib/java_impl/**/*.java'].join ' '}"
  end
  desc 'Number of lines, words, and bytes of Ruby code'
  task :ruby do
    sh "wc #{Dir['lib/ruby_impl/**/*.rb'].join ' '}"
  end
  desc 'Number of lines, words, and bytes of Ruby wrapper code'
  task :wrap do
    sh "wc #{Dir['lib/java_impl/**/*.rb'].join ' '}"
  end
  desc 'Number of lines, words, and bytes of all code'
  task :all do
    sh "wc #{Dir['lib/**/*.*'].join ' '}"
  end
end

module BenchTask
  namespace :bench do
    desc "Benchmark ruby implementation using ruby."
    task :ruby do
      puts "Benchmarking Ruby implementation."
      sh "ruby -Ilib bench/b_front_end.rb --ruby"
    end
    desc "Benchmark ruby implementation using jruby."
    task :jruby do
      puts "Benchmarking JRuby implementation."
      sh "jruby -Ilib bench/b_front_end.rb --ruby"
    end
    desc "Benchmark Java implementation."
    task :java do
      puts "Benchmarking Java implementation."
      sh "jruby -Ilib bench/b_front_end.rb --java"
    end
  end
end

desc 'Benchmark all implementations.'
task :bench => ['bench:ruby', 'bench:java', 'bench:jruby']

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    s.name = "noyes"
    s.summary = "A signal processing library"
    s.description = "A fast portable signal processing library
                     sufficient for creating features for
                     speech recognition, etc.".sub(/\n/, ' ').squeeze ' '
    s.email = "joe@talkhouse.com"
    s.homepage = "http://github.com/talkhouse/noyes"
    s.authors = ["Joe Woelfel"]
    s.files = Dir['lib/ruby_impl/*rb'] + Dir['lib/common/*.rb'] <<
        Dir['lib/java_impl/*.rb'] << Dir['lib/*.rb'] << Dir['ship/*.jar'] <<
        Dir['lib/cext/*.c'] << Dir['lib/cext/*.h'] <<
        Dir['lib/cext/extconf.rb'] << 'VERSION'
    s.extensions = ['lib/cext/extconf.rb']
    s.test_files = []
    s.require_paths = ['lib','ship']
    s.extra_rdoc_files = ['README', 'FAQ', 'COPYING']
    s.add_dependency "trollop", ">= 1.0.0"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end
