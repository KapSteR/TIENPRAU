clear; clc; tic;

disp('Init');

MAIN_DIR = 'D:\PainRecognotion_KasperNielsen_10731\Batch_runs\grey_vector_warping\';
DATA_DIR = 'D:\PainRecognotion_KasperNielsen_10731\Batch_runs\grey_vector_warping\Database\';
% addpath(pwd); % Add current folder to path

cd(MAIN_DIR);

load('data\warped_vectors\g_warped_metaData.mat');

m = size(objectPixels,1);

g_warped_out = cell(nFrames,1);
errorIdx_out = cell(nFrames,1);

nIters = 1000;

for idx = 0:47

	range = (idx*nIters)+1:(idx+1)*nIters;

	load(['data\warped_vectors\g_warped', num2str(idx), '.mat']);

	g_warped_out(range) = g_warped(range);
	errorIdx_out(range) = errorIdx(range);

	toc;disp(num2str(idx));

end


range = (48001:nFrames);
load('data\warped_vectors\g_warped48.mat')

g_warped_out(range) = g_warped(range);
errorIdx_out(range) = errorIdx(range);

toc;disp('Saving data to file');

save('data\warped_vectors\g_warped.mat', 'g_warped_out', 'errorIdx_out');

toc;disp('Finished');

