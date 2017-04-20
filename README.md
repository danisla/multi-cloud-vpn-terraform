# Multi-cloud VPN between AWS and GCP

Reference: https://cloud.google.com/files/CloudVPNGuide-UsingCloudVPNwithAmazonWebServices.pdf

## AWS Config

```
export AWS_ACCESS_KEY_ID=YOUR_AWS_KEY_ID
export AWS_SECRET_ACCESS_KEY=YOUR_AWS_SECRET_KEY
```


## GCP Config

```
export GOOGLE_PROJECT=$(gcloud config get-value project)
export GOOGLE_CREDENTIALS=$(cat ~/.config/gcloud/${USER}-*.json)
```

## Run Terraform

```
echo "EC2_SSH_PUB_KEY = \"$(cat ~/.ssh/google_compute_engine.pub)\"" >> terraform.tfvars
```

```
terraform apply
```


### Extract VPN Info from Customer Configuration

```
export VPN_CONFIG=$(jq -r '.modules[].resources["aws_vpn_connection.aws-vpn-connection1"].primary.attributes.customer_gateway_configuration' terraform.tfstate)

# OR

#export AWS_ACCESS_KEY_ID=
#export AWS_SECRET_ACCESS_KEY=
#export AWS_DEFAULT_REGION=us-west-2
#export VPN_CONFIG=$(aws ec2 describe-vpn-connections | jq -r '.VpnConnections[].CustomerGatewayConfiguration')

export TUN1_VPN_OUTSIDE_IP=$(echo "$VPN_CONFIG" | xmllint --xpath "//ipsec_tunnel[1]/vpn_gateway/tunnel_outside_address/ip_address/text()" -)
export TUN1_SHARED_KEY=$(echo "$VPN_CONFIG" | xmllint --xpath "//ipsec_tunnel[1]/ike/pre_shared_key/text()" -)
export TUN1_PEER_ASN=$(echo "$VPN_CONFIG" | xmllint --xpath "//ipsec_tunnel[1]/vpn_gateway/bgp/asn/text()" -)
export TUN1_CUSTOMER_GW_INSIDE_IP=$(echo "$VPN_CONFIG" | xmllint --xpath "//ipsec_tunnel[1]/customer_gateway/tunnel_inside_address/ip_address/text()" -)
export TUN1_VPN_GW_INSIDE_IP=$(echo "$VPN_CONFIG" | xmllint --xpath "//ipsec_tunnel[1]/vpn_gateway/tunnel_inside_address/ip_address/text()" -)

export TUN2_VPN_OUTSIDE_IP=$(echo "$VPN_CONFIG" | xmllint --xpath "//ipsec_tunnel[2]/vpn_gateway/tunnel_outside_address/ip_address/text()" -)
export TUN2_SHARED_KEY=$(echo "$VPN_CONFIG" | xmllint --xpath "//ipsec_tunnel[2]/ike/pre_shared_key/text()" -)
export TUN2_PEER_ASN=$(echo "$VPN_CONFIG" | xmllint --xpath "//ipsec_tunnel[2]/vpn_gateway/bgp/asn/text()" -)
export TUN2_CUSTOMER_GW_INSIDE_IP=$(echo "$VPN_CONFIG" | xmllint --xpath "//ipsec_tunnel[2]/customer_gateway/tunnel_inside_address/ip_address/text()" -)
export TUN2_VPN_GW_INSIDE_IP=$(echo "$VPN_CONFIG" | xmllint --xpath "//ipsec_tunnel[2]/vpn_gateway/tunnel_inside_address/ip_address/text()" -)
```