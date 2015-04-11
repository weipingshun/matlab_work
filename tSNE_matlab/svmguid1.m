%%
clear
%%
src_data = importdata('svmguide1.format');
train_data = src_data(:,2:5);
label_data = src_data(:,1);

num_dst_dim = 2;
num_initial_dim = 4;
perplexity = 30;
mapped_data = tsne(train_data, [], num_dst_dim, num_initial_dim, perplexity);

gscatter(mapped_data(:,1), mapped_data(:,2), label_data,'br', 'xo');