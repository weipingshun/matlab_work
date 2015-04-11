% generate data
% PRML

%clear
clear

% sin(2*pi*x) x[0,1] 10 data
interval=1/9;
x=0:interval:1;

y = sin(2*pi*x) + wgn(1,10,10*log10(0.09));  %to db

plot(x,y,'o');

%save as file
save('sin_2_p_ix_10_point.mat','x','y');

interval=1/99;
x=0:interval:1;

y = sin(2*pi*x) + wgn(1,100,10*log10(0.09));  %to db

plot(x,y,'o');

%save as file
save('sin_2_p_ix_100_point.mat','x','y');
