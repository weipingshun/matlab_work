%%clear 
clear

data=randn(100,1)*2+3; 
logmodelprior=@(m)0; %use a flat prior. 
loglike=@(m)sum(log(normpdf(data,m(1),m(2)))); 
minit=[0 1]; 
m=mcmc(minit,loglike,logmodelprior,[.2 .5],10000); 
m(1:100,:)=[]; %crop drift 
plotmatrix(m); 