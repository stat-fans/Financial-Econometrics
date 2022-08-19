library("MASS") 

B=399

#define data generation process
DGP<-function(N){
  u=rnorm(2*N)
  y=u
  y[1]=1+u[1]
  for(t in 2:(2*N))
  {
    y[t]=1+0.9*y[t-1]+u[t]
  }
  data=y[(N+1):(2*N)]#X=y[(N+1):(2*N-1)],Y=y[(N+2):(2*N)],without constant
  return(data)
}



#calculate OLS estimation and usual t statistic
OLS<-function(x,Y){
  n=length(x)
  X=cbind(rep(1,n),x)
  b=ginv(t(X)%*%X)%*%t(X)%*%Y 
  s_2=t(Y-X%*%b)%*%(Y-X%*%b)/(n-2)
  SE=sqrt(s_2*(ginv(t(X)%*%X))[2,2])
  t=(b[2]-0.9)/SE     #restricted
  return(rbind(b,SE,t))
}



Student_t<-function(data){
  X=data[1:(length(data)-1)]
  Y=data[2:length(data)]
  n=length(X)
  b=OLS(X,Y)[1:2]     
  SE=OLS(X,Y)[3]
  t=OLS(X,Y)[4]               
  p_t=2*(1-pt(abs(t),(n-2)))
  return(p_t)
}



RR_bootstrap<-function(data){
  X=data[1:(length(data)-1)]
  Y=data[2:length(data)]
  n=length(X)
  b1=mean(Y-X*0.9)
  e=Y-b1-X*0.9
  u=sqrt(n/(n-2))*e
  t_RR=rep(0,B)
  data_star=rep(0,(n+1))
  for (j in 1:B){
    data_star[1]=X[1]
    for (i in 2:(n+1)){
      data_star[i]=b1+0.9*data_star[i-1]+sample(u,size=1,replace=TRUE)
    }
    X_star=data_star[2:n]
    Y_star=data_star[3:(n+1)]
    t_RR[j]=OLS(X_star,Y_star)[4] 
  }
  t=OLS(X,Y)[4]
  p_RR=sum(abs(t_RR)>abs(t))/B
  return(p_RR)
}



UR_bootstrap<-function(data){
  X=data[1:(length(data)-1)]
  Y=data[2:length(data)]
  n=length(X)
  b=OLS(X,Y)[1:2]
  e=Y-b[1]-X*b[2]    ####
  u=sqrt(n/(n-2))*e  
  t_UR=rep(0,B)
  data_star=rep(0,(n+1))
  for (j in 1:B){
    data_star[1]=X[1]
    for (i in 2:(n+1)){
      data_star[i]=b[1]+b[2]*data_star[i-1]+sample(u,size=1,replace=TRUE)
    }
    X_star=data_star[2:n]
    Y_star=data_star[3:(n+1)]
    b_star=OLS(X_star,Y_star)[1:2]
    SE_star=OLS(X_star,Y_star)[3]
    t_UR[j]=(b_star[2]-b[2])/SE_star    #####
  }
  t=OLS(X,Y)[4]
  p_UR=sum(abs(t_UR)>abs(t))/B
  return(p_UR)
}



wild_bootstrap<-function(data){
  X=data[1:(length(data)-1)]
  Y=data[2:length(data)]
  n=length(X)
  b1=mean(Y-X*0.9)
  e=Y-b1-X*0.9  
  
  X1=cbind(rep(1,n),X)
  hat_mat=X1%*%ginv(t(X1)%*%X1)%*%t(X1)#rescaled residual factor
  v=c(1,-1)  
  
  t_wild=rep(0,B)
  data_star=rep(0,n)
  for (j in 1:B){
    data_star[1]=b1+0.9*X[1]+(e[1]/sqrt(1-hat_mat[1,1]))*sample(v,size=1,replace=TRUE,prob=c(0.5,0.5))
    for (i in 2:n){
      data_star[i]=b1+0.9*data_star[i-1]+(e[i]/sqrt(1-hat_mat[(i),(i)]))*sample(v,size=1,replace=TRUE,prob=c(0.5,0.5))
    }
    X_star=data_star[1:(n-1)]
    Y_star=data_star[2:n]
    t_wild[j]=OLS(X_star,Y_star)[4] 
  }
  t=OLS(X,Y)[4]
  p_wild=sum(abs(t_wild)>abs(t))/B
  return(p_wild)
}




pairs_bootstrap<-function(data){
  X=data[1:(length(data)-1)]
  Y=data[2:length(data)]
  DATA=cbind(X,Y)
  n=length(X)
  b=OLS(X,Y)[1:2] #####
  t_pairs=rep(0,B)
  DATA_star=matrix(0,nrow = n,ncol = 2)
  for (j in 1:B){
    for (i in 1:n){
      row=sample(1:n,size=1,replace=TRUE)
      DATA_star[i,]=DATA[row,]
    }
    X_star=DATA_star[,1]
    Y_star=DATA_star[,2]
    b_star=OLS(X_star,Y_star)[1:2]
    SE_star=OLS(X_star,Y_star)[3]
    t_pairs[j]=(b_star[2]-b[2])/SE_star #####
  }
  t=OLS(X,Y)[4]
  p_pairs=sum(abs(t_pairs)>abs(t))/B
  return(p_pairs)
}




reject_fre<-function(N){
  p=matrix(0,5,10000)
  rownames(p)=c("p_t","p_RR","p_UR","p_wild","p_pairs")
  data=replicate(10000,DGP(N)) #matrix:N*10000
  p=apply(data,2,function(x) {
    c(p_t = Student_t(x), p_RR = RR_bootstrap(x),
      p_UR=UR_bootstrap(x),p_wild=wild_bootstrap(x),
      p_pairs=pairs_bootstrap(x))
   }
  )
  rej_fre=matrix(0,5,1)
  rej_fre=apply(p,1,function(x){
    sum(x<0.05)/10000
   }
  )
  return(rej_fre)
}



sample_size <-c(10,14,20,28,40,56,80,113,160,226,320,452,640,905,1280)
rej_fre_all=sapply(sample_size,reject_fre)


