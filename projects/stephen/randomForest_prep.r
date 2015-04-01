#Read in the tables
#This is your table containing your training data
sample=read.table("train_RF6_7.txt", header=1, sep=",")
#This is the table with the class ID of your training data
dep_id=read.table("soil_CBR_id.txt", header=1, sep=",")
# This is the table containing your unknown points (raster)
unknown=read.table("unknown_final.txt", header=1, sep=",")

#Append sample table with the observed dependent variable

train_RF=cbind(dep_id[,3],sample[,5:25])
#Apply logical column names
colnames(train_RF)=
	c("MU","MIN4_3","MIN4_5","MIN3_7","MIN5_2","MIN5_1","MIN4_7",
	"Land1","Land2","Land3","Land4","Land5","Land6","CTI5x5","slope",
	"curve","slope11x11","CTI","lake","aspect","pj","elev")


predict_RF=cbind(unknown[,5:25])
colnames(predict_RF)=
	c("MIN4_3","MIN4_5","MIN3_7","MIN5_2","MIN5_1","MIN4_7",
	"Land1","Land2","Land3","Land4","Land5","Land6","CTI5x5","slope",
	"curve","slope11x11","CTI","lake","aspect","pj","elev")


#Export in CSV format – best format to use in RF
write.csv(train_RF, file="train_RF6_7.csv", row.names=FALSE)
write.csv(predict_RF, file="predict_RFinal.csv", row.names=FALSE)

#exporting results
# Read in the table produced from RF
results=read.table("results_final.csv",header=1,sep=",")
# Here we append the UTM coordinates
results_p=cbind(unknown[,3:4],results[,2])
colnames(results_p)=c("X","Y","prediction")
# Save it all to a .csv to import into ArcGIS
write.csv(results_p, file="result_points6_7b.csv", row.names=FALSE)

# Ignore this, it was a brain storm
(results[1,(!(y==0|y==results[1,2]+2))])
# BELOW
#This is how you find the second and third most likely class

blank=results[,3:26]
high=results[,2]
y=c(1:24)
mat=matrix(y,dim(blank)[1],24,byrow=1)
high_index=mat==high
blank[high_index]=0
second=max.col(blank)

second_index=mat==second
blank[second_index]=0
third=max.col(blank)

second_best=cbind(unknown[,3:4],second)
colnames(second_best)=c("X","Y","second")
write.csv(second_best,file="second6_7b.csv",row.names=FALSE)

third_best=cbind(unknown[,3:4],third)
colnames(third_best)=c("X","Y","third")
write.csv(third_best,file="third6_7b.csv",row.names=FALSE)

#FOURTH component necessary?
third_index=mat==third
blank[third_index]=0
big=blank>=0.2
sum(big)

#Uncertainty
# Below is exporting tables of uncertainty for the three most likely choices
blank=results[,3:26]
blank=t(blank)
third_index=mat==third
uncertain=blank[t(high_index)]
sec_uncertain=blank[t(second_index)]
third_uncertain=blank[t(third_index)]
sum=uncertain+sec_uncertain
third_sum=sum+third_uncertain

uncertain=cbind(unknown[,3:4],uncertain)
colnames(uncertain)=c("X","Y","Uncertainty")
write.csv(uncertain,file="uncertain6_7b.csv",row.names=FALSE)

sec_uncertain=cbind(unknown[,3:4],sec_uncertain)
colnames(sec_uncertain)=c("X","Y","Uncertainty")
write.csv(sec_uncertain,file="sec_uncertain6_7b.csv",row.names=FALSE)

sum=cbind(unknown[,3:4],sum)
colnames(sum)=c("X","Y","Uncertainty")
write.csv(sum,file="sum6_7b.csv",row.names=FALSE)

third_uncertain=cbind(unknown[,3:4],third_uncertain)
colnames(third_uncertain)=c("X","Y","Uncertainty")
write.csv(third_uncertain,file="third_uncertain6_7b.csv",row.names=FALSE)

third_sum=cbind(unknown[,3:4],third_sum)
colnames(third_sum)=c("X","Y","Uncertainty")
write.csv(third_sum,file="third_sum6_7b.csv",row.names=FALSE)

#Summarize variables by class
class=results[,2]
variables=unknown[,5:25]
class_mean=aggregate(variables,list(class),mean)
class_sd=aggregate(variables,list(class),sd)
class_sum=rbind(class_mean,class_sd)
write.csv(class_sum,file="class_summary.csv")

#summarize thematic class PJ

wood=cbind(0,0,0,1:24)[,1:3]
jun=variables[,20]==1
pin=variables[,20]==2
non=variables[,20]==3
c=jun
c[]=1
count=aggregate(c,list(class),sum)

a=aggregate(variables[jun,20],list(class[jun]),sum)
a=type.convert(as.matrix(a))
wood[a[,1],1]=a[,2]

a=aggregate(variables[pin,20],list(class[pin]),sum)
a=type.convert(as.matrix(a))
wood[a[,1],2]=a[,2]/2

a=aggregate(variables[non,20],list(class[non]),sum)
a=type.convert(as.matrix(a))
wood[a[,1],3]=a[,2]/3

percent=wood/count[,2]
write.csv(percent,file="wooded.csv")
