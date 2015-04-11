%% laplace approximation
clear

%{
x = -4:0.1:4;
len = length(x)
sigmodx = 1./(ones(1,len) + exp(-20*x-4));
p = exp((-x.^2)./2).*sigmodx;
logp = -log(p)
%}

syms x;
fp=*exp((-x^2)/2)/(1+exp(-20*x-4));

xv=-2:0.1:4;
pv=subs(fp,'x',xv);
logpv=-log(pv);

dp=diff(fp);
dpzerox=fzero(char(dp),0);  %change dp to string

ddp=diff(dp);    % 2 order
a=-subs(ddp,'x',dpzerox);

q=sqrt(a/(2*pi))*exp(-a*(x-dpzerox)*(x-dpzerox)/2);
qv=subs(q,'x',xv);
logqv=-log(qv);

figure(1);
hold on;
plot(xv,pv,'y');
plot(xv,qv,'r');

figure(2);
hold on;
plot(xv,logpv,'y');
plot(xv,logqv,'r');