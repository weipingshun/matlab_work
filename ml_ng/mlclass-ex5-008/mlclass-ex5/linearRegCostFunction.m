function [J, grad] = linearRegCostFunction(X, y, theta, lambda)
%LINEARREGCOSTFUNCTION Compute cost and gradient for regularized linear 
%regression with multiple variables
%   [J, grad] = LINEARREGCOSTFUNCTION(X, y, theta, lambda) computes the 
%   cost of using theta as the parameter for linear regression to fit the 
%   data points in X and y. Returns the cost in J and the gradient in grad

% Initialize some useful values
m = length(y); % number of training examples
n = size(theta);
% You need to return the following variables correctly 
J = 0;
grad = zeros(n);

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost and gradient of regularized linear 
%               regression for a particular choice of theta.
%
%               You should set J to the cost and grad to the gradient.
%
diff = X * theta - y;
diff_square = diff .^ 2;
J = sum(diff_square)/(2 * m) + theta(2:n)' * theta(2:n) * lambda/(2 * m);
%
% X num_samples * num_features
% diff num_samples * 1
% X' * diff  num_feature * 1
grad = (X' * diff)/m;
grad(2:n) = grad(2:n) + lambda * theta(2:n)/m;

% =========================================================================

grad = grad(:);

end
