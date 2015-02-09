clear; clc; tic;

MAIN_DIR = 'C:\Users\Kasper\Documents\GitHub\TIENPRAU\MATLAB\';
DATA_DIR = 'C:\Users\Kasper\Documents\GitHub\TIENPRAU\MATLAB\Database\';
% addpath(pwd); % Add current folder to path

cd(MAIN_DIR);

load('data\AllShapesAlign.mat');

% Dimensions
[n, m, nFrames] = size(Z);

% Vectorize data
Zv = zeros(nFrames,n*m);

for idx = 1:nFrames

	Zv(idx,:) = [Z(:, 1, idx)' , Z(:, 2, idx)'];

end

% Principal Components Analysis
[Evectors,SCORE,Evalues] = princomp(Zv);

% Keep only 98% of all eigen vectors, (remove contour noise)
i=find(cumsum(Evalues)>sum(Evalues)*0.99,1,'first'); 
Evectors=Evectors(:,1:i);
Evalues=Evalues(1:i);

toc
