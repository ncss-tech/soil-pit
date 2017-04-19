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
ggplot() +
  geom_rect(aes(xmin = as.integer(month), xmax = as.integer(month) + 1,
                ymin = 0, ymax = max(test$depb_r),
                fill = pondfreqcl)) +
  geom_line(aes(x = as.integer(month), y = dept_r, lty = stat)) +
  ylim(max(test$depb_r), 0) +
  facet_wrap(~ paste(compname, comppct_r, "%")) +
  ggtitle("Component Soil Moisture Month")


test %>%
  ggplot() +
  geom_rect(aes(xmin = as.integer(month), xmax = as.integer(month) + 1,
                ymin = 0, ymax = max(test$depb_r),
                fill = pondfreqcl)) +
  ylim(max(test$depb_r), 0) +
  facet_wrap(~ paste(compname, comppct_r, "%")) +
  ggtitle("Component Soil Moisture Month")
