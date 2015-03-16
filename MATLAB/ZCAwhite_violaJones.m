clear; clc; tic;

disp('Init');

MAIN_DIR = 'C:\Users\Kasper\Documents\GitHub\TIENPRAU\MATLAB\';
DATA_DIR = 'C:\Users\Kasper\Documents\GitHub\TIENPRAU\MATLAB\Database\';
% addpath(pwd); % Add current folder to path

cd(MAIN_DIR);

m = matfile(dataset); % FIX PATH;

x = m.dataset;

[nFrames, nPixel] = size(x);

% Compute the mean pixel intensity value separately for each patch. 
uFrame = mean(x, 2);     

% Subtract mean
x = x - repmat(uFrame, nFrames, 1);

% Find eigenvectors using SVD
sigma = (1/(nFrames-1)) * (x'*x);

[U,S,V] = svd(sigma);

% epsilon = 1;
epsilon = 0.1;
% epsilon = 1e-10; 

xZCAWhite = U * diag(1./sqrt(diag(S) + epsilon)) * U' * x;

