function [J, grad] = cofiCostFunc(params, Y, R, num_users, num_movies, ...
                                  num_features, lambda)
%COFICOSTFUNC Collaborative filtering cost function
%   [J, grad] = COFICOSTFUNC(params, Y, R, num_users, num_movies, ...
%   num_features, lambda) returns the cost and gradient for the
%   collaborative filtering problem.
%

% Unfold the U and W matrices from params
X = reshape(params(1:num_movies*num_features), num_movies, num_features);
Theta = reshape(params(num_movies*num_features+1:end), ...
                num_users, num_features);

            
% You need to return the following values correctly
J = 0;
X_grad = zeros(size(X));
Theta_grad = zeros(size(Theta));

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost function and gradient for collaborative
%               filtering. Concretely, you should first implement the cost
%               function (without regularization) and make sure it is
%               matches our costs. After that, you should implement the 
%               gradient and use the checkCostFunction routine to check
%               that the gradient is correct. Finally, you should implement
%               regularization.
%
% Notes: X - num_movies  x num_features matrix of movie features
%        Theta - num_users  x num_features matrix of user features
%        Y - num_movies x num_users matrix of user ratings of movies
%        R - num_movies x num_users matrix, where R(i, j) = 1 if the 
%            i-th movie was rated by the j-th user
%
% You should set the following variables correctly:
%
%        X_grad - num_movies x num_features matrix, containing the 
%                 partial derivatives w.r.t. to each element of X
%        Theta_grad - num_users x num_features matrix, containing the 
%                     partial derivatives w.r.t. to each element of Theta
%
R_valid = R == 1;                 %change nonone to zero
D = (X*Theta' - Y);
D_square =  D.^2;
D_valid  = R_valid .* D;           % row num is num_movies. 
                                   %column_num is num_users.  
%S_valid = R_valid & D_square;     % here S_valid is zero one matrix
D_square_valid = R_valid .* D_square;
J = sum(sum(D_square_valid))/2;

%% X_grad is a matrix. num_movies * num_features
X_grad =  D_valid * Theta; %num_movies_num_users X num_users num_features

%% Theta_grad is a matrix. num_users * num_features
Theta_grad = D_valid'* X;  %num_users_num_movies X num_movies_num_features

%%regularize
theta_reg = sum(sum(Theta .^ 2)) * lambda / 2;
x_reg = sum(sum(X .^ 2)) * lambda / 2;
J = J + theta_reg + x_reg;
X_grad = X_grad + lambda * X;
Theta_grad = Theta_grad + lambda * Theta; 
% =============================================================

grad = [X_grad(:); Theta_grad(:)];

end
