require 'socket'
require 'noyes_protocol'
require 'fcntl'
class MockNoyesServer
  class Session
    attr_accessor :file
    attr_accessor :data
    attr_accessor :magic
    def initialize file
      @file = file
      @data = ''
      @magic = false
    end
  end
  def initialize options
    @server_socket = TCPServer.new('', options.port)
    @server_socket.setsockopt Socket::SOL_SOCKET, Socket::SO_REUSEADDR, 1
    @descriptors = [@server_socket]
    @sessions = {}
    @file_counter = 0
  end
  def run
    while true
      res = select(@descriptors, nil, nil, nil)
      if res
        res[0].each do |sock|
          if sock == @server_socket
            accept_new_connection
          else
            process_available_data sock
          end
        end
      end
    end
  end

  def accept_new_connection
    newsock = @server_socket.accept
    @descriptors.push newsock
    session = Session.new open("session_#{@file_counter+=1}.raw", 'w')
    @sessions[newsock] = session
  end 

  def process_available_data sock
    msg, from = sock.recvfrom 1024
    session = @sessions[sock]
    session.data << msg

    if !session.magic
      if session.data =~ /^#{TMAGIC}/
        session.magic = true
        session.data.slice! 0, TMAGIC.size
      end
    end

    id = session.data.slice(0,4)
    id = session.data.slice!(0,4) if id == TSTART
      
    cepstra = []
    while id == TCEPSTRA && session.data.size >=8
      cep_count = 13 * session.data.slice(4,4).unpack('N')[0]
      break unless cep_count * 4 + TCEPSTRA.size + 4 <= session.data.size
      session.data.slice!(0,8)
      cep_count.times do |i|
        cepstra << session.data.slice!(0,4).unpack('g')[0]
      end
      id = session.data.slice(0,4)
    end
    if id == TEND
      session.data.slice!(0,4) 
      sock.puts 'new england patriots'
      close_socket sock
    end
    session.data.slice!(0,4) if id == TDONE
    
  rescue IOError => e
   p e
  end
  def close_socket sock
    @descriptors.delete sock
    @sessions[sock].file.close
    @sessions.delete sock
    sock.close
  end
end
