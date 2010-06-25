require 'rake/clean'
require 'rake/testtask' 
require 'fileutils'

CLEAN.include 'lib/**/*.o', 'build'
CLOBBER.include 'pkg', 'ship', 'noyes.gemspec', 'lib/c_impl/*.bundle'
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
    sh "jar -cf #{jar} -C build/#{lang}_impl/ ."
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
  `cd lib/c_impl; make`
end

task :jar => 'ship/noyes.jar'
task :default => :build

module Tags
  FILES = FileList['lib/**/*.rb']
end

task :tags do
    sh "ctags --extra=+q -f .tags #{Tags::FILES}", :verbose => false
end

namespace :test do
  ruby_desc = 'Full Ruby implementation test.'
  desc ruby_desc
  task :ruby do
    puts ruby_desc
    sh "ruby -Ilib:test test/ts_all_ruby.rb"
  end
  
  c_desc = 'Test C implementation' 
  desc c_desc 
  task :c => :cext do
    puts c_desc 
    sh "ruby -Ilib:test:ext test/ts_all_c.rb"
  end
  java_desc = 'Full Java implementation test.'
  desc java_desc 
  task :java => :jar do
    puts java_desc 
    sh "jruby -Ilib:test:ship test/ts_all_java.rb"
  end
  jruby_desc = 'Full JRuby implementation test.'
  desc jruby_desc
  task :jruby do
    puts "Testing JRuby implementation."
    sh "jruby -Ilib:test test/ts_all_ruby.rb"
  end
  namespace :ruby do
    fast_ruby_desc = 'Fast (but less thorough) Ruby implementation test.'
    desc fast_ruby_desc
    task :fast do
      puts fast_ruby_desc
      sh "ruby -Ilib:test test/ts_fast_ruby.rb"
    end
  end
  namespace :jruby do
    fast_jruby_desc = 'Fast (but less thorough) JRuby implementation test.'
    desc fast_jruby_desc 
    task :fast do
      puts fast_jruby_desc 
      sh "ruby -Ilib:test test/ts_fast_ruby.rb"
    end
  end
  namespace :java do
    fast_java_desc = 'Fast (but less thorough) Java implementation test.'
    desc fast_java_desc 
    task :fast do
      puts fast_java_desc 
      sh "jruby -Ilib:test:ship test/ts_fast_java.rb"
    end
  end
  desc 'Run fast (but less thorough) tests for all implementations.'
  task :fast  => ['ruby:fast', 'java:fast', 'jruby:fast']
end

desc 'Run all tests for all implementations.'
task :test  => ['test:ruby', 'test:java', 'test:jruby']

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
    s.description = "Currently sufficient to create features for speech recognition"
    s.email = "joe@talkhouse.com"
    s.homepage = "http://github.com/talkhouse/noyes"
    s.authors = ["Joe Woelfel"]
    s.files = Dir['lib/ruby_impl/*rb'] + Dir['lib/common/*.rb'] <<
        Dir['lib/java_impl/*.rb'] << Dir['lib/*.rb'] << Dir['ship/*.jar'] <<
        Dir['lib/c_impl/*.c'] << Dir['lib/c_impl/*.h'] <<
        Dir['lib/c_impl/extconf.rb'] << 'VERSION'
    s.extensions = ['lib/c_impl/extconf.rb']
    s.test_files = []
    s.require_paths = ['lib','ship']
    s.extra_rdoc_files = ['README', 'FAQ', 'COPYING']
    s.add_dependency "trollop", ">= 1.0.0"
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end
