library(leaflet.esri)

leaflet() %>%
  addEsriBasemapLayer(esriBasemapLayers$Imagery) %>%
  setView(-86.28, 39, 20) %>%
  addEsriFeatureLayer(
    url='http://services.arcgis.com/SXbDpmb7xQkk44JV/arcgis/rest/services/Data_Loggers_CB_20170209/FeatureServer/0',
    useServiceSymbology = TRUE)
  
    