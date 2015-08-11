options(stringsAsFactors = FALSE)

library(plyr)

test <- read.csv("test.csv")
test <- read.table("test.txt", header = TRUE, sep = "|")

names(test) <- c("projectiid", "uprojectid", "pname", "muname", "muname2", "natmusym", "liid", "ssa", "musym", "mukey", "mustatus", "acres", "dmudesc")
test$key <- paste0(test$projectiid, "_", test$ssa)
test <- arrange(test, projectiid, ssa, natmusym)


test2_c <- subset(test, mustatus != "Additional")
test2_s <- subset(test, mustatus == "Additional")

test3 <- merge(test2_s, test2_c[c("key", "muname", "natmusym", "musym", "mustatus")], by = "key")

ddply(test3, .(pname, ssa, musym.y), summarise, old_musym = paste0(unique(musym.x), collapse = ", "))

