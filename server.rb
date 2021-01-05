require "socket"

def parse_request(request_line)
  http_method, path_and_params, http = request_line.split
  path, params = path_and_params.split("?")

  params = params.split("&").map { |pair| pair.split("=") }.to_h if params

  [http_method, path, params]
end

server = TCPServer.new("localhost", 3003)
loop do
  client = server.accept

  request_line = client.gets
  next if !request_line || request_line =~ /favicon/
  puts request_line

  http_method, path, params = parse_request(request_line)

  client.puts "HTTP/1.1 200 OK"
  client.puts "Content-Type: text/html"
  client.puts
  client.puts "<!DOCTYPE html>"
  client.puts "<html>"
  client.puts "<body>"
  client.puts "<pre>"
  #client.puts request_line
  client.puts http_method
  client.puts path
  client.puts params
  client.puts "</pre>"

  client.puts "<h1>Rolls!</h1>"
  
  if params
    params["rolls"].to_i.times do 
      client.puts "<p>", rand(params["sides"].to_i) + 1, "</p>"
    end
  end
  #client.puts rand(6) + 1
  client.puts "</body>"
  client.puts "</html>"
  client.close
end
