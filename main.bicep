param acrName string
param acrLocation string
param appServicePlanName string
param appServicePlanLocation string
param webAppName string
param webAppLocation string
param linuxFxVersion string
param appSettings object

module acr './modules/container-registry/registry/main.bicep' = {
  name: '${acrName}-deploy'
  params: {
    name: acrName
    location: acrLocation
    acrAdminUserEnabled: true
  }
}

module appServicePlan './modules/web/serverfarm/main.bicep' = {
  name: '${appServicePlanName}-deploy'
  params: {
    name: appServicePlanName
    location: appServicePlanLocation
    sku: {
      capacity: 1
      family: 'B'
      name: 'B1'
      size: 'B1'
      tier: 'Basic'
    }
    reserved: true
  }
}

module webApp './modules/web/site/main.bicep' = {
  name: '${webAppName}-deploy'
  params: {
    name: webAppName
    location: webAppLocation
    kind: 'app'
    serverFarmResourceId: appServicePlan.outputs.resourceId
    siteConfig: {
      linuxFxVersion: linuxFxVersion
      appCommandLine: ''
    }
    appSettingsKeyValuePairs: appSettings
  }
}
