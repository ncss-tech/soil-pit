library(plyr)

col_names <- c("compkind")
DomainName <- c("component_kind")
cd_names <- data.frame(col_names, DomainName, stringsAsFactors = FALSE)

col_test <- function(col_names, domain_names) {
  which(sapply(col_names, function(x) any(x %in% domain_names)))
}


comp <- get_component_data_from_NASIS_db()
md <- get_metadata()
md <- join(md, cd_names, by = "DomainName", type = "left")

col_test(names(comp), unique(md$col_names))
