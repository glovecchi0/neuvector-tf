# Terraform | Equinix - Preparatory steps

In order for Terraform to run operations on your behalf, you just need to [create an API Keys from your personal profile](https://deploy.equinix.com/developers/docs/metal/accounts/api-keys/).

## Example

#### Option 1 - Setup API Keys using REST API

##### Prerequisites

Create your personal [Access Token](https://developer.equinix.com/dev-docs/ecp/getting-started/getting-access-token).

##### Create your API Keys

```console
curl -X POST \
-H "Content-Type: application/json" \
-H "X-Auth-Token: <API_TOKEN>" \
"https://api.equinix.com/metal/v1/user/api-keys" \
-d '{
    "description": "string",
    "read_only": false    
}'
```

##### Retrieve all the API Keys associated with your user account

```console
curl -X GET -H 'X-Auth-Token: <API_TOKEN>' \
"https://api.equinix.com/metal/v1/user/{id}/api-keys"
```

#### Option 2 - Setup API Keys through the Console

###### Click the icon representing your Avatar at the top right and select _My Profile_

###### Move to the _API Keys_ tab and click _+ Add new key_

#### Use API Keys

```console
export METAL_AUTH_TOKEN=
```
