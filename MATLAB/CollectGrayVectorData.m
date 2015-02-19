clear; clc; tic;

load('data\warped_vectors\g_warped_metaData.mat');

g_warped_out = cell(nFrames,1);
errorIdxOut = cell(nFrames,1);


load('data\warped_vectors\g_warped2.mat');

g_start = 1;
g_end = 7100;

g_warped_out(g_start:g_end) = g_warped(g_start:g_end);
errorIdxOut(g_start:g_end) = errorIdx(g_start:g_end);


load('data\warped_vectors\g_warped3.mat');

g_start = 7101;
g_end = 10000;

g_warped_out(g_start:g_end) = g_warped(g_start:g_end);
errorIdxOut(g_start:g_end) = errorIdx(g_start:g_end);


load('data\warped_vectors\g_warped4.mat');

g_start = 10001;
g_end = 12000;

g_warped_out(g_start:g_end) = g_warped(g_start:g_end);
errorIdxOut(g_start:g_end) = errorIdx(g_start:g_end);


load('data\warped_vectors\g_warped5.mat');

g_start = 12001;
g_end = 16000;

g_warped_out(g_start:g_end) = g_warped(g_start:g_end);
errorIdxOut(g_start:g_end) = errorIdx(g_start:g_end);


load('data\warped_vectors\g_warped6.mat');

g_start = 16001;
g_end = 25100;

g_warped_out(g_start:g_end) = g_warped(g_start:g_end);
errorIdxOut(g_start:g_end) = errorIdx(g_start:g_end);


load('data\warped_vectors\g_warped7.mat');

g_start = 25101;
g_end = 30000;

g_warped_out(g_start:g_end) = g_warped(g_start:g_end);
errorIdxOut(g_start:g_end) = errorIdx(g_start:g_end);


load('data\warped_vectors\g_warped8.mat');

g_start = 30001;
g_end = nFrames;

g_warped_out(g_start:g_end) = g_warped(g_start:g_end);
errorIdxOut(g_start:g_end) = errorIdx(g_start:g_end);

errorIdx = errorIdxOut;
g_warped = g_warped_out;

save('ProcessedData\g_warped_total.mat', 'g_warped', 'errorIdx');
toc