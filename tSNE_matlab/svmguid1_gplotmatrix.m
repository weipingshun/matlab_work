%%
clear
%%
src_data = importdata('svmguide1.format');
train_data = src_data(:,2:5);
label_data = src_data(:,1);

gplotmatrix(train_data, train_data,label_data,'bg','..');