# CI/CD Vars
env = "dev"

# Feature contingent flags, uncomment to enable features
# enable_group_rule = true

# Mocked input for SSO feature
issuer = "https://customer.example.com/test"
sso_url = "https://customer.example.com"
signing_certificate = <<EOF
-----BEGIN CERTIFICATE-----
MIICWDCCAcGgAwIBAgIBADANBgkqhkiG9w0BAQ0FADBJMQswCQYDVQQGEwJ1czES
MBAGA1UECAwJTWlubmVzb3RhMRAwDgYDVQQKDAdFeGFtcGxlMRQwEgYDVQQDDAtl
eGFtcGxlLmNvbTAeFw0xOTA3MjIxMTI3MjlaFw0yMDA3MjExMTI3MjlaMEkxCzAJ
BgNVBAYTAnVzMRIwEAYDVQQIDAlNaW5uZXNvdGExEDAOBgNVBAoMB0V4YW1wbGUx
FDASBgNVBAMMC2V4YW1wbGUuY29tMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKB
gQCmQRXUkb9QWzbtlAmLf6KX5mVTriKAGNJcR3XRwczkwk3TXxdu58hiZo1zs/Jn
C9N6ivaHjCkp/5I4AAu5LkRrAMHRV7MXjbgTZo8m5TbevMNHhenWSsIlHLVrBd5/
KvNA5iUCFJKBUcWdLZXMJMX0aK3thCguLRDdflP7LGFvYQIDAQABo1AwTjAdBgNV
HQ4EFgQUOkwkNgyMslAg7R2KEFRWeicuEBswHwYDVR0jBBgwFoAUOkwkNgyMslAg
7R2KEFRWeicuEBswDAYDVR0TBAUwAwEB/zANBgkqhkiG9w0BAQ0FAAOBgQAo4Vda
C+wJ6l0N5wDeVqCF1yRRLwXNFB2OLrzha1DouKP7x0icz4gNjn1otd7AuVJpMbAs
qvZADc7WbY3hJcnnbEBs4y1+EIU1J0dr8Px7duIl2wcyQSzvTf3+H0Y6i97zR0+8
0wKhh6Fa6knSKlavvLTmyhj6m3aypsM2Aa+v4Q==
-----END CERTIFICATE-----
EOF
