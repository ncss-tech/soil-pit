library(lubridate)
s_by_month<- aggregate(cbind(t_sm_d)~month(obs_date),data=s,FUN=mean)
ggplot(s_by_month, aes(x= `month(obs_date)`,y= t_sm_d))+geom_line(cex=1)+scale_y_reverse()+scale_x_continuous(breaks = 1:12, labels = month.abb, name="Month")+ylim(200, 0)