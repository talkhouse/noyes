require 'rake/clean'
require 'rake/testtask' 
require 'fileutils'

CLEAN.include 'build'
CLOBBER.include 'pkg', 'ship', 'noyes.gemspec'
directory 'ship'

def ensure_dir file
  dir = File.dirname file
  mkdir_p dir unless File.exists? dir
end

def make_jar objs, lang
  jar = "ship/#{lang}impl.jar" 
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
  file 'ship/javaimpl.jar' => OBJ
end

task :build => 'ship/javaimpl.jar'
task :default => :build

module Tags
  FILES = FileList['lib/**/*.rb']
end

task :tags do
    sh "ctags --extra=+q -f .tags #{Tags::FILES}", :verbose => false
end

namespace :test do
  description = 'Full Ruby implementation test.'
  desc description
  task :ruby do
    puts description
    sh "ruby -Ilib:test test/ts_all_ruby.rb"
  end
  description = 'Full Java implementation test.'
  desc description
  task :java => :jar do
    puts "Testing Java implementation."
    sh "jruby -Ilib:test:ship -rjava -rjavaimpl.jar test/ts_all_java.rb"
  end
  description = 'Full JRuby implementation test.'
  desc description
  task :jruby do
    puts "Testing JRuby implementation."
    sh "jruby -Ilib:test test/ts_all_ruby.rb"
  end
  namespace :ruby do
    description = 'Fast (but less thorough) Ruby implementation test.'
    desc description
    task :fast do
      puts description
      sh "ruby -Ilib:test test/ts_fast_ruby.rb"
    end
  end
  namespace :jruby do
    description = 'Fast (but less thorough) JRuby implementation test.'
    desc description
    task :fast do
      puts description
      sh "ruby -Ilib:test test/ts_fast_ruby.rb"
    end
  end
  namespace :java do
    description = 'Fast (but less thorough) Java implementation test.'
    desc description
    task :fast do
      puts description
      sh "jruby -Ilib:test:ship -rjava -rjavaimpl.jar test/ts_fast_java.rb"
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
  SRC = Dir['bench/b_*.rb']
  # For languages that produce java classes in jars
  JARS = Dir['ship/*.jar']
  namespace :bench do
    desc "Benchmark ruby implementation using ruby."
    task :ruby do
      puts "Benchmarking Ruby implementation."
      SRC.each do |src|
        sh "ruby -Ilib:lib/common:lib/ruby_impl #{src}"
      end
    end
    desc "Benchmark ruby implementation using jruby."
    task :jruby do
      puts "Benchmarking JRuby implementation."
      SRC.each do |src|
        sh "jruby -Ilib:lib/common:lib/ruby_impl #{src}"
      end
    end
    desc "Benchmark Java implementation."
    task :java do
      SRC.each do |src|
        puts "Benchmarking java implementation."
        sh "jruby -Ilib:lib/common:lib/java_impl:ship -rjava -rjavaimpl.jar #{src}"
      end
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
        Dir['lib/*.rb'] << Dir['ship/*.jar']
    s.test_files = []
    s.require_paths = ['lib/ruby_impl', 'lib/common', 'lib']
    s.extra_rdoc_files = ['README', 'FAQ', 'COPYING']
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end
