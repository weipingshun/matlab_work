%%clear
clear

% y = x1^2 + X2^2  gradient decent

%init value
init_x_m = [10,8];
pre_x = init_x_m;
x = init_x_m;
learning_rate = 0.1;
while 1
    det_x = pre_x*2;
    x = x - learning_rate * det_x;
    square_pre_x = pre_x.^2;
    pre_y = sum(square_pre_x(:));
    square_x = x.^2;
    y = sum(square_x(:));
    diff = abs(pre_y -y);
    if(diff < 0.005)
          break 
    end
    pre_x = x;
end