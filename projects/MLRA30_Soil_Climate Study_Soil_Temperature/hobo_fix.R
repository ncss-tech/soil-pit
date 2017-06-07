# Read txt file with bad bad format
x<-"MD11_50cm_2000_2003.txt"
test<-read.table(file=x,header=T,sep="\t",stringsAsFactors=F)

# Select date and temp columns manually
test2<-test[,c(1,3,4)]

# Merge date and time columns
test2[,1]<-paste(test[,1]," ",test[,2],sep="")

# Format date and time columns
test3<-as.POSIXlt(test2[,1],format="%m/%d/%Y %H:%M")
test2[,1]<-strftime(test3, format="%m/%d/%y %H:%M:%S")

# Insert NA for tempC with missing data
test2[,3]<-NA

# Fix names of columns
names(test2)<-c("Date Time","Temperature (*F)","Temperature (*C)")

# Write fixed txt file
write.table(test2,file=x,sep="\t",row.names=F,quote=F)




