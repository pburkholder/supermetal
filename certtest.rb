require 'faraday'

ENV['SSL_CERT_FILE'] = './cacert.pem'
print "Trying with no ssl options:\n"
begin
    connection = Faraday::Connection.new 'https://supermarket-0.c.cheffian-supermarket.internal'
    p connection.get '/universe'
    p "WORKED\n\n\n"
rescue Exception => e
    print e.message, "\n\n\n"
end

print "Trying with ssl ca_file options:\n"
begin
    connection = Faraday::Connection.new 'https://supermarket-0.c.cheffian-supermarket.internal', :ssl => { :ca_file => './cacert.pem' }
    p connection.get '/universe'
    p "WORKED\n\n\n"
rescue Exception => e
    print e.message, "\n\n\n"
end
