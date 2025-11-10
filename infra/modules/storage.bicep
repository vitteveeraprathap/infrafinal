param storageName string
param skuName string = 'Standard_LRS'
param kind string = 'StorageV2'
param location string = resourceGroup().location

resource storage 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  name: storageName
  location: location
  sku: {
    name: skuName
  }
  kind: kind
  properties: {
    allowBlobPublicAccess: false
    minimumTlsVersion: 'TLS1_2'
  }
}

output storageAccountName string = storage.name
output storageId string = storage.id
