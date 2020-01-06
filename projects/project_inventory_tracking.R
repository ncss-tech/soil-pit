library(soilDB)
library(dplyr)

Nextcloud <- "C:/Users/stephen.roecker/Nextcloud/data/nwr_data/"

p <- expand.grid(mlrassoarea = c("5-LIN", "5-SAL", "6-HOT", "6-OWN", "6-MAT","6-SPR", "7-MIL", "9-STW", "10-%", "11-%", "12-GRR"),
                 # mlrassoarea = c("11-UNI", "11-AUR", "11-MAN", "11-SPR"),
                 fy          = 2019,
                 projectname = "%",
                 stringsAsFactors = FALSE
                 )
pcor <- {
  split(p, p[c("mlrassoarea", "fy", "projectname")], drop = TRUE) ->.;
  lapply(., function(x) {
    cat("getting the project correlation for", x$mlrassoarea, "and", x$fy, "from NASISWebReport \n")
    get_project_correlation_from_NASISWebReport(x$mlrassoarea, x$fy, x$projectname)
    # get_projectmapunit2_from_NASISWebReport(x$mlrassoarea, x$fy, x$projectname)
  }) ->.;
  do.call("rbind", .) ->.;
  row.names(.) <- 1:nrow(.)
  . ->.;
  }
pcor <- within(pcor, {
  region = sapply(mlrassoarea, function(x) unlist(strsplit(x, "-")[[1]][1]))
  region = as.character(region)
  acre_diff = muacres - new_muacres
  })
fname <- paste0(Nextcloud, "nwr_project_correlation_fy2018_2019_11_14.csv")
# write.csv(pcor, fname, row.names = FALSE)
pcor   <- read.csv(fname, stringsAsFactors = FALSE)

owners <- sf::read_sf(dsn = "C:/workspace2/github/ncss-tech/SSURGO-QA/trunk/SSURGO_Soil_Survey_Area.gdb", layer = "SSA_Regional_Ownership_Master", stringsAsFactors = FALSE)
class(owners) <- "data.frame"


# create matrix of areasymbol by mlrassoarea with sum of spatial changes
# identifies areasymbol with overlapping spatial changes from adjacent mlrassoarea

sc <- filter(pcor, spatial_change == TRUE) %>%
  group_by(mlrassoarea, areasymbol) %>%
  summarize(n = sum(spatial_change)
  ) %>%
  spread(mlrassoarea, n)
idx <- apply(sc[2:ncol(sc)], 1, function(x) sum(!is.na(x)) > 1)
idx2 <- sapply(sc[idx, ], function(x) !all(is.na(x)))
test <- sc[idx, idx2]
write.csv(test, "spatial_overlap.csv", row.names = FALSE)

# Changes in Region 11

in_11 <- subset(pcor, 
                (spatial_change == TRUE | !is.na(pmu_seqnum)) & 
                !projecttypename %in% c("ES", "PES (Obsolete)") & 
                !is.na(new_mukey) &
                areasymbol %in% owners$AREASYMBOL[owners$Region == 11]
                )
in_11 <- merge(in_11, owners[c("AREASYMBOL", "Region")], by.x = "areasymbol", by.y = "AREASYMBOL", all.x = TRUE)

vars <- c("mlrassoarea", "projectname", "areasymbol", "musym", "new_musym", "muacres", "new_muacres")
View(in_11[vars])

group_by(in_11, mlrassoarea) %>% 
  summarize(
    n_areasymbol = length(unique(areasymbol)),
    n_musym = length(unique(new_musym))
  )


# Changes in shared areasymbol from Region 11 and Neighbors

shared <- subset(pcor, 
                (spatial_change == TRUE | !is.na(pmu_seqnum)) & 
                !projecttypename %in% c("ES", "PES (Obsolete)") & 
                !is.na(new_mukey) &
                areasymbol %in% owners$AREASYMBOL[owners$Region == 11] &
                areasymbol %in% areasymbol[! grepl("11-", mlrassoarea)]
)
shared <- merge(shared, owners[c("AREASYMBOL", "Region")], by.x = "areasymbol", by.y = "AREASYMBOL", all.x = TRUE)

vars <- c("mlrassoarea", "projectname", "areasymbol", "musym", "new_musym", "muacres", "new_muacres")
View(shared[vars])

test = group_by(shared, areasymbol) %>% 
  summarize(
    sso11 = paste0(sort(unique(mlrassoarea[grepl("11-", mlrassoarea)])), collapse = ", "),
    sso_n = paste0(sort(unique(mlrassoarea[!grepl("11-", mlrassoarea)])), collapse = ", ")
    # n_areasymbol = length(unique(areasymbol)),
    # n_musym = length(unique(new_musym))
  ) %>%
  filter(sso_n != "" & sso11 != "")


# Changes from neighbors

from_n <- subset(pcor, 
                 !grepl("11-", mlrassoarea) & 
                 (spatial_change == TRUE | !is.na(pmu_seqnum)) & 
                 !projecttypename %in% c("ES", "PES (Obsolete)") & 
                 !is.na(new_mukey) &
                 areasymbol %in% owners$AREASYMBOL[owners$Region == 11]
                 )
from_n <- merge(from_n, owners[c("AREASYMBOL", "Region")], by.x = "areasymbol", by.y = "AREASYMBOL", all.x = TRUE)


vars <- c("mlrassoarea", "projectname", "areasymbol", "musym", "new_musym", "muacres", "new_muacres")
View(from_n[vars])

group_by(from_n, region) %>% 
  summarize(
    n_areasymbol = length(unique(areasymbol)),
    n_musym = length(unique(new_musym))
    )

write.csv(from_n, "region11_spatial_changes_from_neighbors_v2.csv", row.names = FALSE)


# Changes to neighbors

to_n <- subset(pcor, 
               grepl("11-", mlrassoarea) & 
               (spatial_change == TRUE | !is.na(pmu_seqnum)) & 
               !projecttypename %in% c("ES", "PES (Obsolete)") & 
               !is.na(new_mukey) &
               areasymbol %in% owners$AREASYMBOL[owners$Region != 11] 
               )
to_n <- merge(to_n, owners[c("AREASYMBOL", "Region")], by.x = "areasymbol", by.y = "AREASYMBOL", all.x = TRUE)

View(subset(to_n, select = c(mlrassoarea, projectname, areasymbol, musym, new_musym, muacres, new_muacres)))

group_by(to_n, Region) %>% 
  summarize(
    n_areasymbol = length(unique(areasymbol)),
    n_musym = length(unique(new_musym))
    )

write.csv(to_n, "region11_spatial_changes_to_neighbors_v2.csv", row.names = FALSE)


