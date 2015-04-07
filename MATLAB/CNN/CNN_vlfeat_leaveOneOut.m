clear; clc; tic;

disp('Init');

MAIN_DIR = 'D:\PainRecognotion_KasperNielsen_10731\Batch_runs\ViolaJonesPatchExtract\';
% addpath(pwd); % Add current folder to path

cd(MAIN_DIR);

toc; disp('Start')

net = cell(25,1);
info = cell(25,1);

% for leaveOutID = 10:25%25
	leaveOutID = 10
	imdb = leaveOneOutData(leaveOutID);
	[net{leaveOutID}, info{leaveOutID}] = cnn_mnist3(imdb,leaveOutID);

% end

toc;disp('Finished!');