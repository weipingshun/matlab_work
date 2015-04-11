function [models,logP]=mcmc(m,loglikelihood,logmodelprior,stepfunction,mccount,skip)
% Markov Chain Monte Carlo sampling of posterior distribution
%
% [mmc,logP]=mcmc(initialm,loglikelihood,logmodelprior,stepfunction,mccount,skip)
% ---------
%   initialm: starting point fopr random walk
%   loglikelihood: function handle to likelihood function: logL(m)
%   logprior: function handle to the log model priori probability: logPapriori(m)
%   stepfunction: function handle with no inputs which returns a random
%                 step in the random walk. (note stepfunction can also be a
%                 matrix describing the size of a normally distributed
%                 step.)
%   mccount: How long should the markov chain be?
%   skip: Thin the chain by only storing every N'th step [default=10]
%
%
% Note on how to design a stepfunction from the model-covariance matrix:
% Np=size(mmc,2);
% [T,err]=cholcov(cov(mmc)); %see mvnrnd code
% steplength=1; %adjustable parameter
% stepfun=@()randn(1,Np) * T * steplength;
%
% EXAMPLE USAGE: fit a normal distribution to data
% -------------------------------------------
% data=randn(100,1)*2+3;
% logmodelprior=@(m)0; %use a flat prior.
% loglike=@(m)sum(log(normpdf(data,m(1),m(2))));
% minit=[0 1];
% m=mcmc(minit,loglike,logmodelprior,[.2 .5],10000);
% m(1:100,:)=[]; %crop drift
% plotmatrix(m);
%
%
% --- Aslak Grinsted 2010-2014


if nargin==0
    logapriori=@(m)log((m>-2).*(m<2));
    loglikelihood=@(m)0;%log(normpdf(m,1,.3));
    
    m=mcmc(0,loglikelihood,logapriori,1 ,50000,3);
    
    close all
    hist(m(:,1),30)
    title('MCMC.m debug fig. should be flat - w. no edge effects!')
    
    return
end

m=m(:)';
M=length(m);


%TODO:autodetermine stepfunction if not specified. (perhaps differentiate logL near initialm?)
if (nargin<4)||isempty(stepfunction)
    %TODO: determine a good step size...
    error('TODO: autodetermine stepsize')
end

if (nargin<6)||isempty(skip)
    skip=10;
end
Nkeep=floor(mccount/skip);  %wps: total 10000 just keep 1000
mccount=(Nkeep-1)*skip+1;

if ~isa(stepfunction,'function_handle')    %Detect an object of a given MATLAB class or Java class
    stepsize=stepfunction;
    if size(stepsize,1)==size(stepsize,2)
        stepfunction=@()(randn(size(m)))*stepsize;
    else
        stepsize=stepsize(:)';
        stepfunction=@()(randn(size(m))).*stepsize;
    end
end



mtxt='';

reject=[0 0];
accept=[0 0];
hwait = waitbar(0, 'Markov Chain Monte Carlo','name','MCMC');   %A waitbar shows what percentage of a calculation is complete, as the calculation proceeds.
pos=get(hwait,'pos');
%if M<10
set(hwait,'pos',pos+[0 0 0 min(M,10)*12])
%set(hwait,'units','normalized','resize','on')
%uitable(hwait,'units','normalized','pos',[0,1/3,1,2/3],'data',randn(20));
%end
ctime=cputime;
starttime=cputime;

models=nan(Nkeep,M);
logP=nan(Nkeep,2);

logprior=logmodelprior(m);   %wps: m is init point
logL=loglikelihood(m);
models(1,:)=m; logP(1,:)=[logprior loglikelihood(m)];
for ii=2:mccount
    %propose a new m
    proposedm=m+stepfunction(); %stepfun must be symmetric about zero to ensure microscopic reversibility 
    proposed_logprior=logmodelprior(proposedm);
    if log(rand)<proposed_logprior-logprior
        proposed_logL=loglikelihood(proposedm);
        accept(1)=accept(1)+1;
        if log(rand)<proposed_logL-logL
            m=proposedm;
            logL=proposed_logL;
            logprior=proposed_logprior;
            accept(2)=accept(2)+1;
        else
            reject(2)=reject(2)+1;
        end
    else
        reject(1)=reject(1)+1;
    end
    
    if mod(ii-1,skip)==0
        row=ceil(ii/skip);
        models(row,:)=m;
        logP(row,1)=logprior;
        logP(row,2)=logL;
    end
    
    %progress bar
    if cputime-ctime>.3 %dont update progressbar all the time
        rejectpct=sum(reject)/ii;
        Lrejectpct=reject(2)/accept(1); %how many was rejected because of L criteria.
        if M<10
            mtxt=sprintf('%4g\n',m);
        end
        waitbar(ii/mccount,hwait,sprintf('%s%3.0f%% rejected  (L_{reject}=%3.0f%%), ETA: %s',mtxt,rejectpct*100,Lrejectpct*100,datestr((cputime-starttime)*(mccount-ii)/(ii*60*60*24),13)))
        if ~ishandle(hwait)
            error('MCMC interrupted...')
        end
        ctime=cputime;
        drawnow;
    end
end
close(hwait);


% TODO: make standard diagnostics to give warnings...
% TODO: cut away initial drift.(?)
% TODO: make some diagnostic plots if nargout==0;

