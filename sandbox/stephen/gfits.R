RMSD <- function(y,fit){
	RMSD <- round(sqrt(mean((y-fit)^2)),3)
	as.numeric(list(RMSD=RMSD))
}

MD <- function(y,fit){
	MD <- mean(y-fit)
	as.numeric(list(MD=MD))
}

glmfit <- function(glmfit){
	D2 <- round((glmfit$null.deviance-glmfit$deviance)/glmfit$null.deviance,3)
	adjD2 <- round(1-((glmfit$df.null/glmfit$df.residual)*(1-D2)),3)
	RMSE <- round(sqrt(mean((glmfit$y-glmfit$fitted)^2)),3)  
  	MSE <- round(mean((glmfit$y-glmfit$fitted)^2),3)
  	as.data.frame(list(MSE=MSE,RMSE=RMSE,D2=D2,adjD2=adjD2))
}

CVreg <- function(object,model,p,k,dataframe){
  form<-object$formula
  set.seed(131)
  RMSE<- numeric(k)
  for(i in 1:k) RMSE[i] <- errorest(form, data = dataframe,model = model)$error
  cvRMSE<-round(RMSE,3)
  y <- object$y
  n <- length(y)
  nulldf<-n-1
  residualdf<-nulldf-p
  cvD2 <- round(1-(((cvRMSE^2)*n)/sum((y-mean(y))^2)),3)
  cvAdjD2 <- round(1-((nulldf/residualdf)*(1-cvD2)),3)
  as.data.frame(list(cvRMSE=cvRMSE,cvD2=cvD2,cvAdjD2=cvAdjD2))
}

