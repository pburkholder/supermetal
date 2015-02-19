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
