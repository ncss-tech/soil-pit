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


test <- get_cosoilmoist_data_from_NASIS_db()

test %>%
ggplot(aes(x = as.integer(month), y = dept_r, color = stat, lty = pondfreqcl)) +
  geom_line() +
  geom_line(aes(x = as.integer(month), y = depb_r, color = "bottom")) +
  ylim(max(test$depb_r), 0) +
  facet_wrap(~ paste(compname, comppct_r, "%")) +
  ggtitle("Component Soil Moisture Month")
