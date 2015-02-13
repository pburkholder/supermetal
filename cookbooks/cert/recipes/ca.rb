domain = 'cheffian.com'

ssl_certificate domain do
  dir '/tmp/ssl'
  owner 'pburkholder'
  group 'staff'
  common_name 'cheffian_CA'
  key_source 'self-signed'
  cert_source 'self-signed'
end
