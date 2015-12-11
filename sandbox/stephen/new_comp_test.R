library(soilDB)
library(plyr)

options(stringsAsFactors = FALSE)

col_names <- c("compkind", "drainagecl", "frostact", "corcon", "corsteel", "taxorder", "taxsuborder", "taxgrtgroup", "taxsubgrp", "taxpartsize", "taxpartsizemod", "taxceactcl", "taxreaction", "taxtempcl")

DomainName <- c("component_kind", "drainage_class", "potential_frost_action", "corrosion_concrete", "corrosion_uncoated_steel", "taxonomic_order", "taxonomic_suborder", "taxonomic_great_group", "taxonomic_subgroup", "taxonomic_family_particle_size", "taxonomic_family_part_size_mod", "taxonomic_family_c_e_act_class", "taxonomic_family_reaction", "taxonomic_family_temp_class")

cd_names <- data.frame(col_names, DomainName, stringsAsFactors = FALSE)

col_test <- function(col_names, domain_names) {
  which(sapply(col_names, function(x) any(x %in% domain_names)))
}


comp <- get_component_data_from_NASIS_db()
metadata <- get_metadata()
metadata <- join(metadata, cd_names, by = "DomainName", type = "left", match = "first")

col_test(names(comp), unique(metadata$col_names))
