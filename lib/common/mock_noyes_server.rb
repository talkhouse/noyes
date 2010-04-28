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
    puts "accepting new connection"
    newsock = @server_socket.accept
    @descriptors.push newsock
    session = Session.new open("session_#{@file_counter+=1}.raw", 'w')
    @sessions[newsock] = session
  end 

  def process_available_data sock
    msg, from = sock.recvfrom 1024
    return if msg.size == 0
    session = @sessions[sock]
    session.data << msg

    if !session.magic
      if session.data =~ /^#{TMAGIC}/
        session.magic = true
        session.data.slice! 0, TMAGIC.size
        puts "magic! #{msg}"
      end
    end

    id = session.data.slice(0,4)
    id = session.data.slice!(0,4) if id == TSTART
      
    # We just don't really do anything with the cepstra in the mock server.
    cepstra = []
    while id == TCEPSTRA && session.data.size >=8
      cep_count = 13 * session.data.slice(4,4).unpack('N')[0]
      break unless cep_count * 4 + TCEPSTRA.size + 4 <= session.data.size
      session.data.slice!(0,8)
      cepstra.push session.data.slice!(0,cep_count * 4).unpack('g*')
      id = session.data.slice(0,4)
    end
    while (id == TA16_44 || id == TA16_16) && session.data.size >=8
      count = session.data.slice(4,4).unpack('N')[0]
      break unless count * 2 + TA16_44.size + 4 <= session.data.size
      print '.'
      session.data.slice!(0,8)
      audio = session.data.slice!(0,count*2).unpack('n*')
      session.file.write audio.pack 'n*'
      id = session.data.slice(0,4)
    end
    if id == TEND
      session.file.flush
      session.file.close
      session.data.slice!(0,4) 
      sock.puts 'new england patriots'
      close_socket sock
    end
    session.data.slice!(0,4) if id == TBYE
  rescue IOError => e
    puts "\nConnection closed"
  end
  def close_socket sock
    @descriptors.delete sock
    @sessions[sock].file.close
    @sessions.delete sock
    sock.close
  end
end
