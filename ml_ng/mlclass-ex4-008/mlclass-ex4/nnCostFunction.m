function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%
% -------------------------------------------------------------

X = [ones(m,1) X];
%          X num_samples * layer_size(1) + 1
%         Theta1  layer_size(2) * layer_size(1) + 1
hide_Z = X * Theta1';
hide = sigmoid(hide_Z);  %num_samples * layer_size(2)
hide = [ones(m,1) hide];      %num_samples * layer_size(2) + 1
%         Theta2  layer_size(3) * layer_size(2) + 1
output_Z = hide * Theta2';
output = sigmoid(output_Z); % num_samples * layer_size(3)
%        y        layer_size(3) * 1
y_ext = zeros(m,num_labels);   %num_samples * layer_size(3)
for i = 1:m
    y_ext(i,y(i)) = 1;
end
J = sum(sum(log(output) .* (-y_ext) -...
    log(ones(m,num_labels) - output) .* (ones(m,num_labels) - y_ext)));
J = J / m;
% --------------------------------------------------
%reg  
Theta1_nobias = Theta1(:,2:size(Theta1,2));
Theta2_nobias = Theta2(:,2:size(Theta2,2));
J_reg = (sum(sum(Theta1_nobias .^2 )) + sum(sum(Theta2_nobias .^ 2))) * lambda / (2 * m);
J = J + J_reg;

%--------------------------------------------------------
%Grad
hide_Z = [ones(m,1) hide_Z];
output_Z = [ones(m,1) output_Z];
error_3 = output - y_ext;  % num_samples * num_labels
%Theta2  layer_size(3) * layer_size(2) + 1
error_2 = (error_3 * Theta2) .* sigmoidGradient(hide_Z);  %num_samples * layer_size(2) + 1
% hide %num_samples * layer_size(2) + 1
Theta2_grad = error_3' * hide;   % num_labels*num_samples num_samples* layer_size(2) + 1
Theta1_grad = error_2(:,2:size(error_2,2))' * X ;     % layer_size(2)*num_samples num_samples*layer_size(1)
Theta2_grad = Theta2_grad / m;
Theta1_grad = Theta1_grad / m;
%-------------------------------------------------------
%reg
Theta2_cols = size(Theta2_grad,2);
Theta2_grad(:,2:Theta2_cols) = ...
    Theta2_grad(:,2:Theta2_cols) + Theta2(:,2:Theta2_cols) * lambda / m;
Theta1_cols = size(Theta1_grad,2);
Theta1_grad(:,2:Theta1_cols) = ...
    Theta1_grad(:,2:Theta1_cols) + Theta1(:,2:Theta1_cols) * lambda / m;
% =========================================================================
% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];
end
