#!/usr/bin/env jruby
# vim: set filetype=ruby :
ROOT = File.dirname(File.dirname(__FILE__))
$: << "#{ROOT}/lib"
$: << "#{ROOT}/lib/common"
$: << "#{ROOT}/lib/ruby_impl"
require 'socket'
require 'send_incrementally'

def recognize file, node='localhost', port=2318
  TCPSocket.open(node, port) do |client|
    send_incremental_features file, client, client
  end
end

puts recognize ARGV[0]
