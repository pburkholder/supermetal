domain = 'cheffian.com'
ssl_dir = '/tmp/ssl'

ssl_certificate 'cheffian_CA' do
  namespace domain
  dir ssl_dir
  owner 'pburkholder'
  group 'staff'
  common_name 'cheffian_CA'
  key_source 'self-signed'
  cert_source 'self-signed'
end

# openssl x509 -in /tmp/ssl/cheffian_CA.pem (chained.pem is identical)
#     X509v3 extensions:
#            X509v3 Basic Constraints: critical
#                CA:TRUE


ca_cert = ssl_dir + '/cheffian_CA.pem'
ca_key = ssl_dir + '/cheffian_CA.key'

cert = ssl_certificate 'wiki.cheffian.com' do
  common_name self.name
  namespace domain
  dir ssl_dir
  owner 'pburkholder'
  group 'staff'
  key_source 'self-signed'
  cert_source 'with_ca'
  ca_cert_path ca_cert
  ca_key_path ca_key
end

# openssl verify -CAfile /tmp/ssl/cheffian_CA.pem -purpose sslserver /tmp/ssl/wiki.cheffian.com.pem
