function [ cost, grad ] = stackedAECost(theta, inputSize, hiddenSize, ...
                                              numClasses, netconfig, ...
                                              lambda, data, labels)
                                         
% stackedAECost: Takes a trained softmaxTheta and a training data set with labels,
% and returns cost and gradient using a stacked autoencoder model. Used for
% finetuning.
                                         
% theta: trained weights from the autoencoder
% visibleSize: the number of input units
% hiddenSize:  the number of hidden units *at the 2nd layer*
% numClasses:  the number of categories
% netconfig:   the network configuration of the stack
% lambda:      the weight regularization penalty
% data: Our matrix containing the training data as columns.  So, data(:,i) is the i-th training example. 
% labels: A vector containing labels, where labels(i) is the label for the
% i-th training example


%% Unroll softmaxTheta parameter
% tic
% We first extract the part which compute the softmax gradient
softmaxTheta = reshape(theta(1:hiddenSize*numClasses), numClasses, hiddenSize);

% Extract out the "stack"
stack = params2stack(theta(hiddenSize*numClasses+1:end), netconfig);

% You will need to compute the following gradients
softmaxThetaGrad = zeros(size(softmaxTheta));
stackgrad = cell(size(stack));
for d = 1:numel(stack)
    stackgrad{d}.w = zeros(size(stack{d}.w));
    stackgrad{d}.b = zeros(size(stack{d}.b));
end

cost = 0; % You need to compute this

% You might find these variables useful
noOfImages = size(data, 2);
nl = numel(stack)+1;
groundTruth = full(sparse(labels, 1:noOfImages, 1));

%% --------------------------- YOUR CODE HERE -----------------------------
%  Instructions: Compute the cost function and gradient vector for 
%                the stacked autoencoder.
%
%                You are given a stack variable which is a cell-array of
%                the weights and biases for every layer. In particular, you
%                can refer to the weights of Layer d, using stack{d}.w and
%                the biases using stack{d}.b . To get the total number of
%                layers, you can use numel(stack).
%
%                The last layer of the network is connected to the softmax
%                classification layer, softmaxTheta.
%
%                You should compute the gradients for the softmaxTheta,
%                storing that in softmaxThetaGrad. Similarly, you should
%                compute the gradients for each layer in the stack, storing
%                the gradients in stackgrad{d}.w and stackgrad{d}.b
%                Note that the size of the matrices in stackgrad should
%                match exactly that of the size of the matrices in stack.
%

%% forward pass
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


cost = -sumAll(groundTruth.*log(h))/noOfImages;% +lambda*sumAll(theta.^2)/2;

% softmaxThetaGrad = -((groundTruth-h)*softMaxData');
softmaxThetaGrad = -((groundTruth-h)*softMaxData')./noOfImages;% + lambda*softmaxTheta;
 
%% backprob

calc{nl}.d = -softmaxTheta' * (groundTruth-h) .* calc{nl}.a.*(1-calc{nl}.a);
for i = nl-1:-1:2
    calc{i}.d = stack{i}.w' * calc{i+1}.d .* calc{i}.a.*(1-calc{i}.a);
end


for i = 1:nl-1
    stackgrad{i}.w = calc{i+1}.d*calc{i}.a'/noOfImages;% + lambda*stack{i}.w;
    stackgrad{i}.b = sum(calc{i+1}.d,2)/noOfImages;
end

% cost = cost + (1. / noOfImages) * sum((1. / 2) * sum((groundTruth-h).^2));



% -------------------------------------------------------------------------

%% Roll gradient vector
grad = [softmaxThetaGrad(:) ; stack2params(stackgrad)];
% toc
end


% You might find this useful
function sigm = sigmoid(x)
    sigm = 1 ./ (1 + exp(-x));
end
