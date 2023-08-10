#! /bin/bash

if [ "$#" -ne 1 ]
then
  echo "Error: No domain name argument provided"
  echo "Usage: Provide a domain name as an argument"
  exit 1
fi

DOMAIN=$1


mkdir -p pki/root pki/certificates && cd pki


cat > root/root-csr.json <<EOF
{
  "CN": "Root Certificate Authority",
  "key": {
    "algo": "ecdsa",
    "size": 384
  },
  "names": [
    {
      "C": "VN",
      "L": "Ho Chi Minh",
      "O": "Devops"
    }
  ],
  "ca": {
    "expiry": "175200h"
  }
}
EOF


cfssl gencert -initca root/root-csr.json | cfssljson -bare root/root-ca

cat > config.json <<EOF
{
  "signing": {
    "default": {
      "expiry": "26280h"
    },
    "profiles": {
      "intermediate": {
        "usages": [
          "cert sign",
          "crl sign"
        ],
        "expiry": "140160h",
        "ca_constraint": {
          "is_ca": true,
          "max_path_len": 1
        }
      },
      "server": {
        "usages": [
          "signing",
          "digital signing",
          "key encipherment",
          "server auth"
        ],
        "expiry": "26280h"
      }
    }
  }
}
EOF


cat > certificates/${DOMAIN}-csr.json <<EOF
{
  "CN": "DevOps",
  "hosts": [
    "${DOMAIN}",
    "*.${DOMAIN}"
  ],
  "names": [
    {
      "C": "VN",
      "L": "Ho Chi Minh",
      "O": "Hosts Internal",
      "OU": "Internal Hosts"
    }
  ]
}
EOF


cfssl gencert \
  -ca root/root-ca.pem \
  -ca-key root/root-ca-key.pem \
  -config config.json \
  -profile server \
  certificates/${DOMAIN}-csr.json \
| cfssljson -bare certificates/${DOMAIN}
