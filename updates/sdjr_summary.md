# SDJR and MLRA Summary
Stephen Roecker  
December 12, 2016  





```r
setwd("C:/Users/stephen/ownCloud/Documents/lims_data")

### Set parameters
ro <- 11
pt <- c("SDJR")
pt2 <- c("SDJR", "MLRA", "INITIAL", "ES")

# ## Fetch data from the server
# 
# data(state); st <- tolower(state.abb)
# # ssa <- read.dbf("M:/geodata/soils/soilsa_a_nrcs.dbf")
# # st <- sort(unique(substr(ssa$areasymbol, 1, 2)))
# asymbol <- paste0(st, "%25")
# project_id <- "%25"
# years <- 2012:2016; start_date <- paste0("10/01/", years - 1); finish_date <- paste0("10/01/", years)
# 
# goals <- lapply(years, function(x){
#   cat("fetching", x, "goal\n")
#   goals_report(x, "%25")
#   }); goals <- do.call("rbind", goals)
# 
# # rcors <- mapply(function(years, start_date, finish_date){
#   cat("fetching", years, "reverse correlation\n")
#   sdjr_correlation(asymbol, project_id, start_date, finish_date)
#   }, years, start_date, finish_date, SIMPLIFY = FALSE); rcors <- do.call("rbind", rcors)


## Load data from files

corr_dates <- "2015_09_24"
goal_dates <- "2016_12_13"
corr_files <- paste0("lims_correlation_fy", 2012:2015, "_", corr_dates, ".csv")
goal_files <- paste0("lims_goals_fy", substr(2012:2016, 3, 4), "_", goal_dates, ".csv")

rcors.. <- {lapply(corr_files, read.csv) ->.; do.call("rbind", .)}
rcors16 <- read.csv("lims_correlation_fy2016_AK%25_WY%25_2016_09_19.csv")
goals <- {lapply(goal_files, read.csv) ->.; do.call("rbind", .)}
load(file = "ssa.Rdata"); ssa -> ssa2
# ssa <- read.csv("M:/geodata/soils/SSA_Regional_Ownership_MASTER_MLRA_OFFICE.csv", stringsAsFactors = FALSE)
# ssa_r11 <- ssa[ssa$Region == 11, "AREASYMBOL"]

## House Cleaning

### rcors
old_names <- c("sso", "old_musym", "old_natsym", "new_natsym", "old_mukey", "old_acres", "new_acres", "old_muname", "spatial", "old_musym2")
new_names <- c("office", "musym", "nationalmusym", "new_nationalmusym", "mukey", "muacres", "new_muacres", "muname", "spatial_change", "musym_orig")
names(rcors..)                              <- tolower(names(rcors..))
names(rcors..)[which(names(rcors..) %in% old_names)] <- new_names
rcors.. <- transform(rcors..,
                     projecttypename = substr(projectname, 1, 4),
                     state = substr(areasymbol, 1, 2)
                     )
rcors16 <- subset(rcors16, !is.na(new_mukey))
rcors16 <- transform(rcors16, 
                     state = substr(areasymbol, 1, 2)
                     )

match_names <- names(rcors..)[names(rcors..) %in% names(rcors16)]
rcors <- merge(rcors.., rcors16, all = TRUE)
rcors <- subset(rcors, select = match_names)


### goals
old_names <- c("ssoffice", "projecttype")
new_names <- c("office", "projecttypename")
names(goals)[which(names(goals) %in% old_names)] <- new_names

### save copy

save(rcors, file = paste0("rcors_fy_summary_", corr_dates, "_", format(Sys.time(), "%Y_%m_%d.Rdata")))
save(goals, file = paste0("goals_fy_summary_", goal_dates, "_", format(Sys.time(), "%Y_%m_%d.Rdata")))
```


## Estimate Workload


```r
fte <- c(2, 2.5, 3, 2.5, 3, 5, 3, 5, 4, 1, 3)
wdays <- (52*5-10-3*5)*.75 # 52 weeks per year, 5 days per week, minus 10 holidays, minus 3 weeks vaction, at 75% an individuals time (i.e. minus 15% for TSS and 10% for miscellaneous)
# projects per person = 69 projects/ 3.5 fte
# days per project = workingdays/projects per person 

days_p_person <- function(days, projects, fte){
  days/(projects/fte)
}

goals_test <- mutate(goals,
                     mapunit = ifelse(projectname %in% c("^SDJR"), projectname, NA),
                     mapunit = sapply(projectname, function(x) unlist(strsplit(x, " - "))[3]),
                     components = sapply(mapunit, function(x) unlist(strsplit(x, " "))[1])
                     )

test <- filter(goals_test, region %in% ro) %>%
  group_by(office) %>%
  summarize(
    n_projects = length(unique(projectname)),
    n_mapunits = length(unique(mapunit)),
    n_majors = length(unique(sapply(components, function(x) unlist(strsplit(x, "-"))[1])))
    ) %>%
  as.data.frame()

test <- mutate(test,
               fte = round(fte, 1),
               days = round(fte*wdays, 0),
               days_project_fte = round(days / (n_projects / fte), 0), days_major_fte = round(days / (n_majors / fte), 0)
               )
test2 <- rbind(test, c("Average", 
                       round(apply(test[2:8], 2, mean), 0))
               )
test2
```

```
##     office n_projects n_mapunits n_majors fte days days_project_fte
## 1   11-ATL        242        240       43   2  352                3
## 2   11-AUR         94         94       42 2.5  441               12
## 3   11-CLI        188        188       67   3  529                8
## 4   11-FIN         64         58       15 2.5  441               17
## 5   11-GAL        176        173       51   3  529                9
## 6   11-IND        152        149       53   5  881               29
## 7   11-JUE        259        257      132   3  529                6
## 8   11-MAN        150        147       36   5  881               29
## 9   11-SPR         81         70       23   4  705               35
## 10  11-UNI         53         50       25   1  176                3
## 11  11-WAV        322        316       36   3  529                5
## 12 Average        162        158       48   3  545               14
##    days_major_fte
## 1              16
## 2              26
## 3              24
## 4              74
## 5              31
## 6              83
## 7              12
## 8             122
## 9             123
## 10              7
## 11             44
## 12             51
```

## Examine Reported Acres


```r
temp <- goals %>%
  filter(region == ro & projecttypename %in% pt2) %>%
  group_by(fy, office, projecttypename) %>%
  summarize(
    goaled = sum(goaled),
    reported = sum(reported)
    )
rank <- sort(tapply(temp$reported, list(temp$office), sum))
temp <- transform(temp,
                  office = factor(office, levels = sort(unique(temp$office), decreasing = TRUE)),
                  projecttypename = factor(projecttypename, levels = pt2)
                  )

ggplot(temp, aes(x = reported, y = office)) + 
  geom_point() + 
  facet_grid(~ projecttypename ~ fy, scales = "free_x") +
  ggtitle("Time Series of Acres Reported")
```

![](sdjr_summary_files/figure-html/goals-1.png)<!-- -->



```r
ggplot(temp, aes(x = fy, y = reported, group = office, linetype = office, shape = office)) + 
  geom_line(size = 0.7) + 
  geom_point(size = 2.5) +
  scale_shape_manual(values=1:nlevels(temp$office)) +
  facet_grid(projecttypename ~ ., scales = "free_y")
```

![](sdjr_summary_files/figure-html/goals2-1.png)<!-- -->


## Compare Project Acres to Goaled Acres


```r
rcors_acres <- group_by(rcors, fy, region, office, projectname, projectiid, areasymbol) %>%
  summarize(
    n = length(unique(musym_orig)), 
    old_acres = sum(unique(muacres)), 
    new_acres = sum(unique(new_muacres))
    ) %>%
  group_by(fy, region, office, projectname) %>% 
  summarize(
    n = sum(n),
    old_acres = sum(old_acres),
    new_acres = sum(new_acres)
    ) %>%
  as.data.frame()

temp <- merge(goals, rcors_acres, by = "projectname", all.x = TRUE)

progress <- temp %>%
  group_by(region.x, fy.x, projecttypename) %>% 
  summarize(reported = sum(reported) / 0.2,
            new_acres = sum(new_acres, na.rm = TRUE),
            dif_acres = sum(reported - new_acres, na.rm = TRUE),
            dif_pct = 100 - round(reported / new_acres * 100)
            ) %>%
  as.data.frame()

rank <- sort(tapply(progress$reported, list(progress$region.x), sum))

subset(progress, region.x == ro & projecttypename %in% pt)
```

```
##     region.x fy.x projecttypename reported new_acres dif_acres dif_pct
## 216       11 2013            SDJR 14683105  14518199    164906      -1
## 218       11 2014            SDJR 24150585  24332646   -182061       1
## 221       11 2015            SDJR 21141050  21182385    -41335       0
## 225       11 2016            SDJR 13828070  13786315     41755       0
```

```r
# dotplot(region ~ r_goaled | , data = progress, as.table = TRUE)
```


## Map Progress by AREASYMBOL


```r
rcors_as <- filter(rcors, region == ro & projecttypename %in% pt) %>%
  group_by(fy, region, projectiid, projecttypename, areasymbol) %>%
  summarize(
    n = length(unique(new_mukey)), 
    muacres = sum(unique(muacres)), 
    new_muacres = sum(unique(new_muacres))
  ) %>%
  group_by(fy, region, areasymbol) %>%
  summarize(
    muacres = sum(muacres),
    new_muacres = sum(new_muacres)
  ) %>%
  as.data.frame()

rcors_as$acres <- cut(rcors_as$new_muacres, breaks = c(0, 10000, 50000, 100000, 150000, 200000), labels = c("0 - 10,000", "10,000 - 50,000", "50,000 - 100,000", "100,000 - 150,000", "150,000 - 200,000"))

rcors_as_w <- reshape(rcors_as, idvar = "areasymbol", v.names = "acres", timevar = "fy", direction = "wide")
# rcors_as_w1 <- dcast(rcors_as, region + areasymbol ~ fy, value.var = "new_muacres", sum) # inserts 0 instead of NA
# rcors_as_w2 <- spread(rcors_as, fy, muacres) # this doesn't aggregate, would need to be followed

fy <- paste0("acres.", sort(unique(rcors_as$fy)))
FY <- paste0("FY", sort(unique(rcors_as$fy)))
names(rcors_as_w)[which(names(rcors_as_w) %in% fy)] <- FY

ssa2$state <- substr(ssa2$areasymbol, 1, 2)
st <- toupper(c("ia", "il", "in", "ks", "ky", "mi", "mn", "mo", "ne", "oh", "ok", "sd", "wi"))

ssa3 <- merge(ssa2, rcors_as_w, by = "areasymbol", all.x = TRUE)
temp_sub1 <- subset(ssa3, region == ro, select = FY)
#temp_sub2 <- subset(ssa3, state %in% st, select = FY)
bb <- bbox(temp_sub1)

spplot(temp_sub1,
       main = paste0("Time Series of Updated ", paste0(pt, collapse = " & "), " Acres by County"),
       #xlim = bb[1, ], ylim = bb[2, ],
       as.table = TRUE,
       col.regions = brewer.pal(5, "YlOrRd"),
       colorkey = list(space = "bottom", height = 1)
       )
```

![](sdjr_summary_files/figure-html/map_as-1.png)<!-- -->


## Summarize and plot acres by musym


