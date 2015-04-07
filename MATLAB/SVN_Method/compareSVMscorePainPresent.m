clear; 
clc; tic;

disp('Init');

MAIN_DIR = 'D:\PainRecognotion_KasperNielsen_10731\Batch_runs\grey_vector_warping\';
DATA_DIR = 'D:\PainRecognotion_KasperNielsen_10731\Batch_runs\grey_vector_warping\Database\';
addpath(genpath('D:\PainRecognotion_KasperNielsen_10731\libsvm-3.20'));

cd(MAIN_DIR);
addpath(pwd); % Add current folder to path

toc; disp('Load data');

SPTS = struct;

m = matfile('data\compareSVMresultsPainPtsFull.mat');

testTarget = m.testTarget;
SPTS.testTarget = testTarget{11};
SPTS.testData = m.testData;
model = m.model;
SPTS.model = model{11};


CAPP = struct;

m = matfile('data\compareSVMresultsPainAppBalanced.mat');

testTarget = m.testTarget;
CAPP.testTarget = testTarget{11};
CAPP.testData = m.testData;
model = m.model;
CAPP.model = model{11};


FULL = struct;

m = matfile('data\compareSVMresultsPainAllBalanced.mat');

testTarget = m.testTarget;
FULL.testTarget = testTarget{11};
FULL.testData = m.testData;
model = m.model;
FULL.model = model{11};

toc;disp('Evaluate AUC');

figure(1)
auc = ones(3,1)*-Inf;

auc(1) = plotroc(SPTS.testTarget, SPTS.testData, SPTS.model);
hold on
auc(2) = plotroc(CAPP.testTarget, CAPP.testData, CAPP.model);
auc(3) = plotroc(FULL.testTarget, FULL.testData, FULL.model);

% plot(randn(2,1))
% hold on
% plot(randn(2,1))
% plot(randn(2,1))
% hold off

legend(...
	sprintf('S-PTS | AUC = %0.2f\n',100*auc(1)), ...
	sprintf('C-APP | AUC = %0.2f\n',100*auc(2)), ...
	sprintf('S-PTS + C-APP | AUC = %0.2f\n',100*auc(3)), ...
	'Location', 'southeast' ...
	)
plot([0,1],[0,1],'k--')

hold off
toc;disp('Finished!');

