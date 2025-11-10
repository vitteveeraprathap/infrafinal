targetScope = 'subscription'

param rgName string
param location string

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: rgName
  location: location
  tags: {
    createdBy: 'github-actions'
  }
}

output name string = rg.name
output id string = rg.id
