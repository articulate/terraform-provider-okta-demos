FROM hashicorp/terraform:full

RUN apk add --update jq perl openssl wget unzip curl

# Install latest Okta Terraform provider
RUN curl -s https://api.github.com/repos/articulate/terraform-provider-okta/releases/latest \
    | grep "browser_download_url.*linux-amd64" | cut -d : -f 2,3 | tr -d \" | wget -qi -

RUN mkdir -p /root/.terraform.d/plugins/linux_amd64
RUN unzip terraform-provider-okta-linux-amd64.zip -d /root/.terraform.d/plugins/linux_amd64
