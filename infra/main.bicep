targetScope = 'subscription'

// infra/main.bicep
@description('Deployment location for the resource group')
param location string = 'southeastasia'

@description('Resource group name (will be created via subscription-scoped module)')
param rgName string

// control flags
param deployStorage bool = true
param deployKeyVault bool = true
param deployContainer bool = true

// storage params
param storageName string = ''
param storageSku string = 'Standard_LRS'
param storageKind string = 'StorageV2'

// keyvault params
param keyVaultName string = ''
@allowed([ 'standard', 'premium' ])
param keyVaultSkuName string = 'standard'
param enableSoftDelete bool = true
param enablePurgeProtection bool = false

// container params
param containerName string = ''

// ------------------------------------------------------------------
// Create resource group using a subscription-scoped module
// ------------------------------------------------------------------
module rgModule 'modules/resourceGroup.bicep' = {
  name: 'createRg'
  scope: subscription()
  params: {
    rgName: rgName
    location: location
  }
}

// ------------------------------------------------------------------
// Deploy Storage into the created RG (resourceGroup scope)
// Add dependsOn to ensure RG exists first
// ------------------------------------------------------------------
module storageMod 'modules/storage.bicep' = if (deployStorage) {
  name: 'storageDeployment'
  scope: resourceGroup(rgName)
  dependsOn: [
    rgModule
  ]
  params: {
    storageName: storageName
    skuName: storageSku
    kind: storageKind
    location: location
  }
}

// ------------------------------------------------------------------
// Deploy Key Vault into the created RG (resourceGroup scope)
// ------------------------------------------------------------------
module kvMod 'modules/keyvault.bicep' = if (deployKeyVault) {
  name: 'keyvaultDeployment'
  scope: resourceGroup(rgName)
  dependsOn: [
    rgModule
  ]
  params: {
    kvName: keyVaultName
    location: location
    skuName: keyVaultSkuName
    enableSoftDelete: enableSoftDelete
    enablePurgeProtection: enablePurgeProtection
  }
}

// ------------------------------------------------------------------
// Create blob container in storage account (resourceGroup scope)
// ------------------------------------------------------------------
module containerMod 'modules/storageContainer.bicep' = if (deployContainer) {
  name: 'containerDeployment'
  scope: resourceGroup(rgName)
  dependsOn: [
    rgModule
    storageMod
  ]
  params: {
    storageAccountName: storageName
    containerName: containerName
  }
}


output resourceGroupName string = rgName
