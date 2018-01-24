# SD quick anal

dsp_pr %>%
  filter(!is.na(BD_core_fld) & Comp_layer==1) %>%
  ggplot(aes(y=BD_core_fld, x=Soil)) +geom_boxplot(aes(fill = COND)) 
 
dsp_pr %>%
  filter(!is.na(Tot_C) & Comp_layer==1) %>%
  ggplot(aes(y=Tot_C, x=Soil)) +geom_boxplot(aes(fill = COND)) 



B <- combo %>%
  filter(!is.na(BD)) %>%
  ggplot(aes(y = BD, x=SET)) + geom_boxplot(aes(fill=LU)) +
  facet_wrap(~M) + ggtitle('Bulk density by Master Horizon and Land Use/Cover Class')
B