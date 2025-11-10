param storageAccountName string
param containerName string

// reference existing storage account in same resource group
resource st 'Microsoft.Storage/storageAccounts@2023-01-01' existing = {
  name: storageAccountName
}

// reference blob service (name 'default') as existing resource under storage account
resource blobSvc 'Microsoft.Storage/storageAccounts/blobServices@2021-09-01' existing = {
  parent: st
  name: 'default'
}

// create the container as a child of the blob service (name must not contain slashes)
resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-09-01' = {
  parent: blobSvc
  name: containerName
  properties: {
    publicAccess: 'None'
  }
}

output containerNameOut string = container.name
