#!/usr/bin/env bash
export OS_AUTH_URL=https://chi.tacc.chameleoncloud.org:5000/v3
export OS_IDENTITY_API_VERSION=3
export OS_INTERFACE=public
export OS_PROJECT_ID="e081833d8dde4102af564ed96f10035a"
export OS_USERNAME="mtang11@hawk.iit.edu@accounts.google.com"
# export OS_USER_DOMAIN_ID="d17ec186e19457a2660b8d2acc4aa67790eea0af10036914e74914210bc10793"
# export OS_PROJECT_DOMAIN_NAME="chameleon"
export OS_PROTOCOL="openid"
export OS_AUTH_TYPE="v3oidcpassword"
echo "($OS_USERNAME) Please enter your Chameleon CLI password: "
read -sr OS_PASSWORD_INPUT
export OS_PASSWORD=$OS_PASSWORD_INPUT
export OS_IDENTITY_PROVIDER="chameleon"
export OS_DISCOVERY_ENDPOINT="https://auth.chameleoncloud.org/auth/realms/chameleon/.well-known/openid-configuration"
export OS_CLIENT_ID="keystone-tacc-prod"
export OS_ACCESS_TOKEN_TYPE="access_token"
export OS_CLIENT_SECRET="none"
export OS_REGION_NAME="CHI@TACC"
if [ -z "$OS_REGION_NAME" ]; then unset OS_REGION_NAME; fi


# export OS_PROJECT_DOMAIN_NAME="chameleon"
# export OS_USER_DOMAIN_ID="d17ec186e19457a2660b8d2acc4aa67790eea0af10036914e74914210bc10793"