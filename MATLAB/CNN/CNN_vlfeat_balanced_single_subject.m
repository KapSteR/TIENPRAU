clear; clc; tic;

disp('Init');

MAIN_DIR = 'D:\PainRecognotion_KasperNielsen_10731\Batch_runs\ViolaJonesPatchExtract\';
% addpath(pwd); % Add current folder to path

cd(MAIN_DIR);

toc; disp('Start')

[net, info] = cnn_mnist2();


toc;disp('Finished!');