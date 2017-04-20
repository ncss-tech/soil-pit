pm <- read.csv("C:/workspace/SOD_pmgrpname.txt", stringsAsFactors = FALSE)

names(pm) <- tolower(names(pm))
names(pm)[9] <- "pm"

pm_df <- data.frame(
  sort(table(pm$pm), decreasing = TRUE)
  )

test <- within(pm, {
  pm_new = NA
  pm_new[grepl("outwash", pm)] <- "outwash"
})

library(ggplot2)
library(gridExtra)


test <- get_cosoilmoist_data_from_NASIS_db()
test <- get_cosoimoist_from_SDA_db(c("5c33", "5c32"))
test <- subset(test, !is.na(dept_r))

# test <- split(test, test$dmuiid)

ggplot(test) +
  geom_rect(aes(xmin = as.integer(month), xmax = as.integer(month) + 1,
                ymin = 0, ymax = max(test$depb_r),
                fill = pondfreqcl)) +
  geom_line(aes(x = as.integer(month), y = dept_r, 
                lty = status), cex = 1) +
  geom_linerange(aes(x = as.integer(month), 
                     ymin = dept_l, ymax = dept_h), cex = 1.3) +
  ylim(max(test$depb_r), 0) +
#  facet_wrap(~ paste(compname, comppct_r, "%", dmuiid, sep = "-")) +
  facet_wrap(~ paste(compname, comppct_r, "%", mukey, sep = "-")) +
  ggtitle("Component Soil Moisture Month")

