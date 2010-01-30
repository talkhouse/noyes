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
  
  objs.each {|obj| file jar => obj}
  objtrunc = objs.map {|obj| obj.sub /^build\/duby\//, ''}
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

module DubyBuild
  SRC = Dir['lib/duby/**/*.duby']
  OBJ = SRC.map {|s| s.pathmap "%{^lib,build}X.class"}
  SRC.zip(OBJ).each do |src, obj|
    file obj => src do
      ensure_dir obj
    sh "pwd"
      sh "cd lib/duby; dubyc #{src.sub /^lib\/duby\//, ''}"
      mv src.sub(/duby$/, 'class'), obj
    end
  end
  make_jar OBJ, 'duby'
end

task :build => JavaBuild::OBJ + DubyBuild::OBJ
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
    sh "jruby -Ilib/common:lib/ruby:test test/ts_all.rb"
  end
  desc 'Test java implementation'
  task :java => :jar do
    sh "jruby -Ilib/common:lib/java:ship:test -rjava -rjavaimpl.jar test/ts_all.rb"
  end
  desc 'Thoroughly test java implementation'
  task :alljava => :jar do
    sh "jruby -Ilib/common:lib/java:ship:test -rjava -rjavaimpl.jar test/tc_s4.rb"
  end
  desc 'Test ruby implementation under default ruby'
  task :ruby do
    sh "ruby -Ilib/common:lib/ruby:test test/ts_all.rb"
  end
end

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
      SRC.each do |src|
        sh "ruby -Ilib/common:lib/ruby #{src}"
      end
    end
    desc "Benchmark ruby implementation using jruby."
    task :jruby do
      SRC.each do |src|
        sh "jruby -Ilib/common:lib/ruby #{src}"
      end
    end
    desc "Benchmark java implementation."
    task :java do
      SRC.each do |src|
        sh "jruby -Ilib/common:lib/java:ship -rjava -rjavaimpl.jar #{src}"
      end
    end
  end
end
