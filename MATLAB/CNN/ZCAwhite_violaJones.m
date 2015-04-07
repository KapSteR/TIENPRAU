clear; clc; tic;

disp('Input data');

MAIN_DIR = 'D:\PainRecognotion_KasperNielsen_10731\Batch_runs\ViolaJonesPatchExtract\';
DATA_DIR = 'D:\PainRecognotion_KasperNielsen_10731\Database\';
% addpath(pwd); % Add current folder to path

cd(MAIN_DIR);

m = matfile('facePatches48.mat'); % FIX PATH;

x = m.facePatches;
facePatchesMetaData = m.facePatchesMetaData;

[r, c, nFrames] = size(x);

nPixel = r*c;

% Reshape data from r x c x nFrames -> nFrames x nPixel
x = reshape(x,nPixel,nFrames)';

% Compute the mean pixel intensity value separately for each patch. 
toc;disp('Remove mean from each image');
uFrame = mean(x, 2);     

% Subtract mean
x = x - repmat(uFrame, 1, nPixel);

% Find eigenvectors using SVD
toc;disp('Calculate covariance matrix and SVD');
sigma = (1/(nFrames-1)) * (x'*x);

[U,S,V] = svd(sigma);

% Set regularization parameter: epsilon
% epsilon = 1;
epsilon = 0.1;
% epsilon = 1e-10; 

toc; disp('Make ZCA whitening');
ZCAmatrix = U * diag(1./sqrt(diag(S) + epsilon)) * U';

xZCAWhite = x * ZCAmatrix;

% Reshape data from nFrames x nPixel -> r x c x nFrames
xZCAWhite = reshape(xZCAWhite', r, c, nFrames);

toc;disp('Save data to file');
save('facePatchesWhite48.mat', 'xZCAWhite', 'facePatchesMetaData', 'ZCAmatrix')

toc;disp('Finished!');