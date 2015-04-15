function p = predict(Theta1, Theta2, X)
%PREDICT Predict the label of an input given a trained neural network
%   p = PREDICT(Theta1, Theta2, X) outputs the predicted label of X given the
%   trained weights of a neural network (Theta1, Theta2)

% Useful values
m = size(X, 1);
num_labels = size(Theta2, 1);

% You need to return the following variables correctly 
p = zeros(size(X, 1), 1);

% ====================== YOUR CODE HERE ======================
% Instructions: Complete the following code to make predictions using
%               your learned neural network. You should set p to a 
%               vector containing labels between 1 to num_labels.
%
% Hint: The max function might come in useful. In particular, the max
%       function can also return the index of the max element, for more
%       information see 'help max'. If your examples are in rows, then, you
%       can use max(A, [], 2) to obtain the max for each row.
%
%         layer:      1 2 3
%         layer_size: 400 25 10
%         Theta1:     layer_size[2] * (layer_size[1] + 1)
%         Theta2:     layer_size[3] * (layer_size[2] + 1)
%         X:          num_samples * (layer_size[1] + 1)

X = [ones(m, 1) X];
H = sigmoid(X * Theta1');    % hide  num_samples * layer_size[2]  
h_size = size(H, 1);
H = [ones(h_size,1) H];
Q = sigmoid(H * Theta2');
[m p] = max(Q,[],2);



% =========================================================================


end
