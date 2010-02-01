require 'rake/clean'
require 'rake/testtask' 
require 'fileutils'

CLEAN.include('build', 'ship')
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
    sh "jar -cf #{jar} -C build/#{lang}/ ."
  end
end

module JavaBuild
  SRC = Dir['lib/java/**/*.java']
  OBJ = SRC.map {|s| s.pathmap "%{^lib,build}X.class"}
  SRC.zip(OBJ).each do |src, obj|
    file obj => src do
      puts "object  = #{obj}"
      ensure_dir obj
      sh "javac -source 1.5 -Xlint -d build/java #{SRC.join ' '}"
    end
  end
  make_jar OBJ, 'java'
end

task :build => JavaBuild::OBJ
task :default => :build

module Tags
  FILES = FileList['doc/**/*.txt', 'lib/**/*.rb']
end

task :tags do
    sh "ctags --extra=+q -f .tags #{Tags::FILES}", :verbose => false
end

namespace :test do
  desc 'Test ruby implementation under jruby'
  task :jruby do
    sh "jruby -Ilib:lib/common:test:lib/ruby_impl test/ts_all.rb"
  end
  desc 'Test java implementation'
  task :java => :jar do
    include_path = '-Ilib:lib/common:test:lib/java_impl:ship'
    sh "jruby #{include_path} -rjava -rjavaimpl.jar test/ts_all.rb"
  end
  desc 'Test ruby implementation under default ruby'
  task :ruby do
    sh "ruby -Ilib:lib/common:test:lib/ruby_impl test/ts_all.rb"
  end
  desc 'Quick test of the Ruby implemenation.'
  task :quick do
    sh "ruby -Ilib:lib/common:test:lib/ruby_impl test/ts_fast.rb"
  end
end

desc 'Test all implementations.'
task :test  => ['test:ruby', 'test:java', 'test:jruby']

namespace :wc do
  desc 'Number of lines, words, and bytes of Java code'
  task :java do
    sh "wc #{Dir['lib/java/**/*.java'].join ' '}"
  end
  desc 'Number of lines, words, and bytes of Ruby code'
  task :ruby do
    sh "wc #{Dir['lib/ruby/**/*.rb'].join ' '}"
  end
  desc 'Number of lines, words, and bytes of Ruby wrapper code'
  task :wrap do
    sh "wc #{Dir['lib/java/**/*.rb'].join ' '}"
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
      puts "Benchmarking Ruby implemenation."
      SRC.each do |src|
        sh "ruby -Ilib:lib/common:lib/ruby_impl #{src}"
      end
    end
    desc "Benchmark ruby implementation using jruby."
    task :jruby do
      puts "Benchmarking JRuby implemenation."
      SRC.each do |src|
        sh "jruby -Ilib:lib/common:lib/ruby_impl #{src}"
      end
    end
    desc "Benchmark Java implementation."
    task :java do
      SRC.each do |src|
        puts "Benchmarking java implemenation."
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
    s.description = "Currently sufficient to create basic features for speech recognition"
    s.email = "joe@talkhouse.com"
    s.homepage = "http://github.com/talkhouse/noise"
    s.authors = ["Joe Woelfel"]
    s.files = Dir['lib/ruby_impl/*rb'] + Dir['lib/common/*.rb'] << Dir['lib/*.rb']
    s.test_files = []
    s.require_paths = ['lib/ruby_impl', 'lib/common', 'lib']
    s.extra_rdoc_files = ['README', 'doc/syntax.rb']
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end
