domain = 'cheffian.com'
ssl_dir = '/tmp/ssl'
ca_cert = ssl_dir + '/cheffian_CA.pem'
ca_key = ssl_dir + '/cheffian_CA.key'
owner = 'pburkholder'
group = 'staff'

%w(chefserver.cheffian.com supermarket.cheffian.com).each do |common_name|
  ssl_certificate common_name do
    common_name self.name
    namespace domain
    dir ssl_dir
    owner owner
    group group
    key_source 'self-signed'
    cert_source 'with_ca'
    ca_cert_path ca_cert
    ca_key_path ca_key
  end
end

# openssl verify -CAfile /tmp/ssl/cheffian_CA.pem -purpose sslserver /tmp/ssl/wiki.cheffian.com.pem
