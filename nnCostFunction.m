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

Delta_1 = 0;
Delta_2 = 0;

Theta1_remove1 = Theta1(:,2:end);   % [25 400]
Theta2_remove1 = Theta2(:,2:end);   % [10 25]

new_X = [ones(m,1) X]; %[5000 401]

diff = 0;

for i = 1:m
    new_y = zeros(num_labels,1); %[10 1]
    new_y(y(i)) = 1;
    a1 = new_X(i,:);     % [1 401]
    z2 = Theta1 * a1';   % [25 1]
    a2 = sigmoid(z2);    % [25 1] 
    a2_add1 = [1; a2];   % [26 1]
    a3 = sigmoid(Theta2 * a2_add1); %[10 1]
    
    diff = sum((-new_y).*log(a3) - (1 - new_y).*log(1 - a3)) + diff;
    
    delta_3 = a3 - new_y; % [10 1]
    %              [25 10]       [10 1]           [25 1]
    delta_2 = (Theta2_remove1' * delta_3).* sigmoidGradient(z2);  % [25 1]
    %        [25 401]  [25 1]    [1 401]
    Delta_1 = Delta_1 + delta_2 * a1;
    %        [10 26]   [10 1]    [1 26]
    Delta_2 = Delta_2 + delta_3 * a2_add1';
    
end

Theta1_grad = Delta_1/m;
Theta2_grad = Delta_2/m;

Theta1_grad(:,2:end) = Theta1_grad(:,2:end) + lambda/m * Theta1_remove1;
Theta2_grad(:,2:end) = Theta2_grad(:,2:end) + lambda/m * Theta2_remove1;

grad = [Theta1_grad(:) ; Theta2_grad(:)];

reg_term = (sum(Theta1_remove1(:).^2) + sum(Theta2_remove1(:).^2))*lambda/(2*m);
J = diff/m + reg_term;




















% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
