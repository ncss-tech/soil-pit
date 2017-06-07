
test <- get_cosoilmoist_from_NASIS()
test$facetor <- factor(paste0(test$compname, "(",test$comppct_r, "%)"))

# remove depths with NA
test <- subset(test, !is.na(dept_r))
test <- subset(test, status != "Not_Populated")

ggplot(test,aes(x=as.integer(month),y=dept_r))+geom_rect(aes(xmin=as.integer(month),xmax=as.integer(month)+1,ymin=dept_r,ymax=depb_r,fill=status))+
  xlab("month") + ylab("depth (cm)") +   ylim(200,0) +
  scale_x_continuous(breaks = 1:12, labels = month.abb, name="Month")+
  facet_grid(dmuiid ~ facetor) 