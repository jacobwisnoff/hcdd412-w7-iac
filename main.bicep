@description('Globally unique base name for the web app and App Service plan.')
param appName string

@description('Deployment environment.')
@allowed([
  'dev'
  'staging'
  'prod'
])
param environment string

@description('Azure region where the resources will be deployed.')
param location string = resourceGroup().location

var resourceName = '${appName}-${environment}'

// Linux App Service plan using the least-cost Linux-supported Basic tier.
resource appServicePlan 'Microsoft.Web/serverfarms@2023-12-01' = {
  name: '${resourceName}-plan'
  location: location
  kind: 'linux'
  sku: {
    name: 'B1'
    tier: 'Basic'
    capacity: 1
  }
  properties: {
    reserved: true
  }
}

// Linux web app configured to accept HTTPS traffic only.
resource webApp 'Microsoft.Web/sites@2023-12-01' = {
  name: resourceName
  location: location
  kind: 'app,linux'
  properties: {
    serverFarmId: appServicePlan.id
    httpsOnly: true
    siteConfig: {
      linuxFxVersion: 'NODE|20-lts'
      minTlsVersion: '1.2'
      ftpsState: 'Disabled'
    }
  }
}

resource lang 'Microsoft.CognitiveServices/accounts@2023-05-01' = {
  name: 'lang-${appName}-${environment}'
  location: location
  kind: 'TextAnalytics'
  sku: {
    name: 'F0'
  }
  properties: {
    customSubDomainName: 'lang-${appName}-${environment}'
    publicNetworkAccess: 'Enabled'
  }
}

output languageEndpoint string = lang.properties.endpoint
