function [cost, grad] = softmaxCost(theta, numClasses, inputSize, lambda, data, labels)

% numClasses - the number of classes 
% inputSize - the size N of the input vector
% lambda - weight decay parameter
% data - the N x M input matrix, where each column data(:, i) corresponds to
%        a single test set
% labels - an M x 1 matrix containing the labels corresponding for the input data
%

% Unroll the parameters from theta
theta = reshape(theta, numClasses, inputSize);

noOfImages = size(data, 2);
if ((size(labels,1) == 1) || (size(labels,2) == 1))
    groundTruth = full(sparse(labels, 1:noOfImages, 1));
else
    groundTruth = labels;
end
cost = 0;

thetagrad = zeros(numClasses, inputSize);

%% ---------- YOUR CODE HERE --------------------------------------
%  Instructions: Compute the cost and gradient for softmax regression.
%                You need to compute thetagrad and cost.
%                The groundTruth matrix might come in handy.

M = theta*data;
M = bsxfun(@minus, M, max(M, [], 1));
% maxVal = max(thetaX(:));
expThetaX = exp(M);
h = bsxfun(@rdivide, expThetaX, sum(expThetaX));
cost = -sumAll(groundTruth.*log(h))/noOfImages;
% cost = -sumAll((1-groundTruth).*log(1-h)+groundTruth.*log(h))/noOfImages;

thetagrad = -((groundTruth-h)*data')/noOfImages;
 
 



% ------------------------------------------------------------------
% Unroll the gradient matrices into a vector for minFunc
grad = thetagrad(:);
end

