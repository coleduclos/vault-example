import os
import requests
import hvac
import json

vault_url = 'http://localhost'
vault_port = '8200'
vault_url = vault_url + ':' + vault_port
vault_api_version = 'v1'
role_name = 'ratings-service-role'


vault_client = hvac.Client(url=vault_url, token=os.environ['VAULT_TOKEN'])

role_id = vault_client.get_role_id(role_name)

request_url = vault_url + '/' + vault_api_version + '/auth/approle/role/' + role_name + '/secret-id'
headers = {'X-Vault-Token':os.environ['VAULT_TOKEN'], 'X-Vault-Wrap-TTL':'10s'}
response = requests.post(request_url, headers = headers)
if response.status_code == 200:
    response = json.loads(response.text)
    unwrapped_response = vault_client.unwrap(response['wrap_info']['token'])
    secret_id = unwrapped_response['data']['secret_id']
    print vault_client.auth_approle(role_id, secret_id)
else:
    print("ERROR {}: {}".format(response.status_code, response.text))

