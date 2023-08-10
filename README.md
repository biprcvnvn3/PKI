# Install cfssl first

`````````````````````````
curl -SLO https://github.com/cloudflare/cfssl/releases/download/v1.5.0/cfssl_1.5.0_linux_amd64 \
&& curl -SLO https://github.com/cloudflare/cfssl/releases/download/v1.5.0/cfssljson_1.5.0_linux_amd64

chmod +x cfssl_1.5.0_linux_amd64 cfssljson_1.5.0_linux_amd64

mv cfssl_1.5.0_linux_amd64 /usr/local/bin/cfssl && \
mv cfssljson_1.5.0_linux_amd64 /usr/local/bin/cfssljson

