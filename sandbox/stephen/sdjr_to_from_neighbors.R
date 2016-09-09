# Changes from neighbors

library(dplyr)

corr_sub_11n <- subset(corr, corr$region != 11 & spatial_change == TRUE & projecttypename != "ES" & !is.na(new_mukey))
owners_sub_11 <- subset(owners, Region == 11)

from_n <- merge(corr_sub_11n, owners_sub_11, by.x = "areasymbol", by.y = "AREASYMBOL", all = FALSE)
from_n$acre_diff <- with(from_n, muacres - new_muacres)

group_by(from_n, region) %>% summarize(
  n_areasymbol = length(unique(areasymbol)),
  n_musym = length(unique(new_musym)))

write.csv(from_n, "region11_spatial_changes_from_neighbors.csv", row.names = FALSE)

# Changes to neighbors

corr_sub_11 <- subset(corr, corr$region == 11 & spatial_change == TRUE & projecttypename != "ES" & !is.na(new_mukey))
owners_sub_11n <- subset(owners, Region != 11)

to_n <- merge(corr_sub_11, owners_sub_11n, by.x = "areasymbol", by.y = "AREASYMBOL", all = FALSE)

group_by(to_n, Region) %>% summarize(
  n_areasymbol = length(unique(areasymbol)),
  n_musym = length(unique(new_musym)))

write.csv(to_n, "region11_spatial_changes_to_neighbors.csv", row.names = FALSE)
