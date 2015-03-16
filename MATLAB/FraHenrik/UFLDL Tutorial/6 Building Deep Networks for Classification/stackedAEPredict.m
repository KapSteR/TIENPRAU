function [pred] = stackedAEPredict(theta, inputSize, hiddenSize, numClasses, netconfig, data)
                                         
% stackedAEPredict: Takes a trained theta and a test data set,
% and returns the predicted labels for each example.
                                         
% theta: trained weights from the autoencoder
% visibleSize: the number of input units
% hiddenSize:  the number of hidden units *at the 2nd layer*
% numClasses:  the number of categories
% data: Our matrix containing the training data as columns.  So, data(:,i) is the i-th training example. 

% Your code should produce the prediction matrix 
% pred, where pred(i) is argmax_c P(y(c) | x(i)).
 
%% Unroll theta parameter

% We first extract the part which compute the softmax gradient
softmaxTheta = reshape(theta(1:hiddenSize*numClasses), numClasses, hiddenSize);

% Extract out the "stack"
stack = params2stack(theta(hiddenSize*numClasses+1:end), netconfig);

noOfImages = size(data, 2);
nl = numel(stack)+1;
%% ---------- YOUR CODE HERE --------------------------------------
%  Instructions: Compute pred using theta assuming that the labels start 
%                from 1.

calc = cell(nl,1);
calc{1}.a = data;

for i = 1:nl-1
    calc{i+1}.z = stack{i}.w * calc{i}.a + stack{i}.b*ones(1,noOfImages);
%     calc{i+1}.z = bsxfun(@plus, calc{i+1}.z, stack{i}.b);
    calc{i+1}.a = sigmoid(calc{i+1}.z);
end

softMaxData = calc{nl}.a; 
M = softmaxTheta*softMaxData;
M = bsxfun(@minus, M, max(M, [], 1));
% maxVal = max(thetaX(:));
expThetaX = exp(M);
h = bsxfun(@rdivide, expThetaX, sum(expThetaX));

[~, pred] = max(h, [], 1);








% -----------------------------------------------------------

end


% You might find this useful
function sigm = sigmoid(x)
    sigm = 1 ./ (1 + exp(-x));
end
