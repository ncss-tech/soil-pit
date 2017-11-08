#gracenet anal

#get and combine gracenet data
BD_data <- "C:/Users/skye.wills/ownCloud/BD_eval/"  #shortcut for personal use

# natres.url <- 'https://www.cloudvault.usda.gov/index.php/s/4AY9kGm6TVBD2u6/download'
# ifelse(!file.exists(paste0(BD_data, '/natres.xlsx'),download.file(natres.xlsx, destfile = paste0(BD_data,'/data/natres.csv')), "File already downloaded")

library(readxl)
library(tidyverse)

site <- read_excel(paste0(BD_data, "data/natres.xlsx"), sheet ="FieldSites" )
names(site) <- gsub(" ", "_", names(site)) #fix names so that there are no spaces
names(site)[1] <- "SiteID" #fix names so that Site ID matches Treatments and units

units <- read_excel(paste0(BD_data, "data/natres.xlsx"), sheet ="ExperUnits" ) 
names(units) <- gsub(" ", "_", names(units))
names(units) <- gsub("%", "pct", names(units)) #fix names so that there are no %(special character)
names(units)[1] <- "SiteID" #fix names so that Site ID matches Treatments and sites


trt <- read_excel(paste0(BD_data, "data/natres.xlsx"), sheet ="Treatments" )
names(trt) <- gsub(" ", "_", names(trt))
names(trt)[1] <- "SiteID" #fix names so that Site ID matches sites and units

phys <- read_excel(paste0(BD_data, "data/natres.xlsx"), sheet = "MeasSoilPhys")
names(phys) <- gsub(" ", "_", names(phys))
names(phys) <- gsub("%", "pct", names(phys)) #fix names so that there are no %(special character)
names(phys) <- gsub("/", "per", names(phys)) #fix names so that there are no /(special character)

chem <- read_excel(paste0(BD_data, "data/natres.xlsx"), sheet = "MeasSoilChem")  
names(chem) <- gsub(" ", "_", names(chem))
names(chem) <- gsub("%", "pct", names(chem)) #fix names so that there are no %(special character)
names(chem) <- gsub("/", "per", names(chem)) #fix names so that there are no /(special character)

bio <- read_excel(paste0(BD_data, "data/natres.xlsx"), sheet = "MeasSoilBiol")  
names(bio) <- gsub(" ", "_", names(bio))
names(bio) <- gsub("/", "per", names(bio)) #fix names so that there are no /(special character)

             #join descriptors             
grnt <- site %>% select(SiteID, Date, Elev = Elevation_m, lat = Latitude_decimal_deg, lon = Longitude_decimal_deg, 
                             Spatial_Description, Native_Veg, MAP = MAP_mm, MAT = MAT_degC) %>%
              left_join(units %>% select(SiteID, Treatment_ID, Exp_Unit_ID, Field_ID, Slope_pct, lat_unit = Latitude, lon_unit = Longitude, 
                                         Soil.taxa = Soil_Classification, size_unit = Exp_Unit_Size_m2) %>% 
                left_join(trt %>%  select(SiteID, Treatment_ID, Treatment_Descriptor, till = Tillage_Descriptor, Cover_Crop) %>%
         #join to soil measurements
                  left_join(phys %>% select(SiteID, Exp_Unit_ID, Treatment_ID, Upper_cm, Lower_cm, Sand = Sand_pct, Silt = Silt_pct, Clay = Clay_pct,
                                        BD = Bulk_Density_gpercm3, AggStab = H2O_Stable_Aggregates_pct) %>%
                    left_join(chem %>% select(SiteID, Exp_Unit_ID, Treatment_ID, SOC = Organic_C_gCperkg, TSC_gCperkg, pH) %>%
                        left_join(bio %>% select(SiteID, Exp_Unit_ID, Treatment_ID, bg = Glucosidase_mgperkgperhr, POM_gCperkg)
                        )))))
  
   
# Graphs of BD and OM
G <- grnt %>% filter(!is.na(BD) & !is.na(SOC))


G %>% ggplot(aes(x = SOC) + geom_density()
 
G %>%
  ggplot(aes(y = BD, x=SOC)) + geom_point() +
  ggtitle('BD and SOC')




#bee swarm
B <- G %>%
  filter(!is.na(BD)) %>%
  ggplot(aes(x=BD, y = till, color = BD)) +  
  geom_quasirandom(alpha=0.82, groupOnX=FALSE) + 
  scale_color_gradientn(colours = cet_pal(10, name = "cyclic_mrybm_35-75_c68_n256"), name = "BD")+
  theme_joy() +
  theme(plot.caption=element_text(hjust=0,size=9),
        axis.title=element_text(size=12),
        plot.title=element_text(size=24))+
  labs(x="Bulk Density",y="Dataset",caption="GRACEnet by @wills_skye", title="Beeswarm Plot of BD by Tillage Class")

B          

#add SOC measurement for visulaization
B_C <- combo %>%
  filter(!is.na(BD)&!is.na(SOC) ) %>%
  ggplot(aes(x=BD, y = SET, color = SOC)) +  
  geom_quasirandom(alpha=0.82, groupOnX=FALSE) + 
  scale_color_viridis()+
  theme_joy() +
  theme(plot.caption=element_text(hjust=0,size=9),
        axis.title=element_text(size=12),
        plot.title=element_text(size=24))+
  labs(x="Bulk Density",y="Dataset",caption="@wills_skye", title="Beeswarm Plot of BD by Dataset")

B_C

#limit to organic horizons
#bee swarm
Bo <- combo %>%
  filter(!is.na(BD) & M =='O') %>%
  ggplot(aes(x=BD, y = SET, color = BD)) +  
  geom_quasirandom(alpha=0.82, groupOnX=FALSE) + 
  scale_color_gradientn(colours = cet_pal(10, name = "cyclic_mrybm_35-75_c68_n256"), name = "BD")+
  theme_joy() +
  theme(plot.caption=element_text(hjust=0,size=9),
        axis.title=element_text(size=12),
        plot.title=element_text(size=24))+
  labs(x="Bulk Density",y="Dataset",caption="@wills_skye", title="Bulk Density of Organic Horizons \n by Dataset")

Bo

Bow <- combo %>%
  filter(!is.na(BD) & M =='O' & LU =='W') %>%
  ggplot(aes(x=BD, y = SET, color = BD)) +  
  geom_quasirandom(alpha=0.82, groupOnX=FALSE) + 
  scale_color_gradientn(colours = cet_pal(10, name = "cyclic_mrybm_35-75_c68_n256"), name = "BD")+
  theme_joy() +
  theme(plot.caption=element_text(hjust=0,size=9),
        axis.title=element_text(size=12),
        plot.title=element_text(size=24))+
  labs(x="Bulk Density",y="Dataset",caption="@wills_skye", title="Bulk Density of O Horizons \n in Wetlands by Dataset")

Bow

#with SOC measurement
BowC <- combo %>%
  filter(!is.na(BD) &!is.na(SOC) & M =='O' & LU =='W') %>%
  ggplot(aes(x=BD, y = SET, color = SOC)) +  
  geom_quasirandom(alpha=0.82, groupOnX=FALSE) + 
  scale_color_viridis(option = "magma")+
  theme_joy() +
  theme(plot.caption=element_text(hjust=0,size=9),
        axis.title=element_text(size=12),
        plot.title=element_text(size=24))+
  labs(x="Bulk Density",y="Dataset",caption="@wills_skye", title="Bulk Density of O Horizons \n in Wetlands by Dataset")

BowC

BowT <- G  %>%
  ggplot(aes(x=BD, y = , color =Upper_cm)) +  
  geom_quasirandom(alpha=0.5, groupOnX=FALSE) + 
  scale_color_viridis(option = "magma")+
  theme_joy() +
  theme(plot.caption=element_text(hjust=0,size=9),
        axis.title=element_text(size=12),
        plot.title=element_text(size=24))+
  labs(x="Bulk Density",y="Dataset",caption="@wills_skye", title="Bulk Density of O Horizons \n in Wetlands by Dataset")

BowT                  
                                                    