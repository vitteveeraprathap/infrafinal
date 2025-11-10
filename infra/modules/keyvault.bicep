param kvName string
param location string = resourceGroup().location
param skuName string = 'standard'
param enableSoftDelete bool = true
param enablePurgeProtection bool = false

resource kv 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: kvName
  location: location
  properties: {
    tenantId: subscription().tenantId
    sku: {
      family: 'A'
      name: skuName
    }
    accessPolicies: []
    enableSoftDelete: enableSoftDelete
    // Only set purge protection to true; do not try to disable it later
    // This avoids "cannot be set to false" error
    enablePurgeProtection: enablePurgeProtection ? true : null
  }
}

output keyVaultName string = kv.name
output keyVaultId string = kv.id
