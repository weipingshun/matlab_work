%%clear
clear all;

%% load traning data
data_1_count=500;
data_2_count=500;
load('2_class_data','data_1','data_2');
label_1=zeros(500,1);   %class_1 label
label_2=ones(500,1);    %class_2 label

% random train data
tran_data_count=data_1_count+data_2_count;
tran_data=[data_1;data_2]';
tran_label=[label_1;label_2]';

rand_idx=randperm(tran_data_count);
tran_data_rand=tran_data(:,rand_idx);
tran_data_label=tran_label(rand_idx);

%% net topo  2 -> 3 ->1
%  tanh(x) 
layer_count=3; 
layer_unit_count=[2,3,1]; 
%random weight
weight=cell(1);
output=cell(1);
delta=cell(1);
for i=1:1:layer_count-1
    weight{i}=rand(layer_unit_count(i),layer_unit_count(i+1));
end

for i=1:1:layer_count
    output{i}=zeros(layer_unit_count(i),1);
    delta{i}=zeros(layer_unit_count(i),1);
end


%% train  (all 1D data use colume vector)
max_iter=1;
learning_rate=0.1;
%one iterater
for iter=1:1:max_iter
    fprintf('iter:%d\n',iter);
    %one sample
    for sample=1:1:tran_data_count
        fprintf('sample:%d ',sample);
        %forward
        for layer=2:1:layer_count
            if layer == 2
                output{layer-1} = tran_data(:,sample);
            end
            cur_sample=output{layer-1};
            cur_weight=weight{layer-1};      % d[layer]*d[layer+1]
            output{layer} = cur_weight'*cur_sample;
            if layer < layer_count
                output{layer} = tanh(output{layer});
            end
        end
        

        
        % delta (every hint unit and output unit have delta)
        for layer=layer_count:-1:2
            %output layer delta 
            if layer == layer_count
                delta{layer}=output{layer} - tran_label(sample);
                fprintf( 'old:%f',delta{layer});
                continue;
            end
            
            %hint layer delta
            for cur_unit=1:1:layer_unit_count(layer)
                delta{layer}(cur_unit) = 0;
                for next_unit=1:1:layer_unit_count(layer+1)
                   % cur_weight_mat = weight{layer};
                    cur_weight = weight{layer}(cur_unit,next_unit);
                    next_delta = delta{layer+1}(next_unit);
                    delta{layer}(cur_unit) = delta{layer}(cur_unit) + cur_weight*next_delta;
                end
                drivative=1-tanh(output{layer}(cur_unit))^2;
                delta{layer}(i) = delta{layer}(i)*drivative;
            end
        end   
            
        %update weight
        for layer=1:1:layer_count-1
            delta_weight = output{layer}*delta{layer+1}';   
            weight{layer} = weight{layer} - learning_rate*delta_weight;
        end
        fprintf('\n');
    end
end


figure(1)
hold on
scatter3(data_1(:,1),data_1(:,2), zeros(500,1), 'r+');  % 3-d drawn point 
hold on
scatter3(data_2(:,1),data_2(:,2), zeros(500,1), 'b*');
%%draw nnet mesh






 



