require "socket"
require "resolv"

BASE_DOMAIN = "tun.server-backend.co.uk"
MAX_LABEL_LENGTH = 63
MAX_TOTAL_LENGTH = 254

puts "Running DNS Server"
puts "Max Payload Length: #{254 - BASE_DOMAIN.length}"

u_sock = UDPSocket.new
u_sock.bind("0.0.0.0", 53)

Socket.udp_server_loop_on([u_sock]) do |msg, sender|
  query = Resolv::DNS::Message.decode(msg)

  query.each_question do |question|
    question_text = question.to_s
    query.add_answer(question_text, 300, Resolv::DNS::Resource::IN::TXT.new(SecureRandom.hex(3)))
  end

  query.qr = 1    # Set query response bit
  sender.reply(query.encode)
end
