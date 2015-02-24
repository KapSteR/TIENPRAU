clear; clc; tic;

disp('Init');

MAIN_DIR = 'C:\Users\Kasper\Documents\GitHub\TIENPRAU\MATLAB\';
DATA_DIR = 'C:\Users\Kasper\Documents\GitHub\TIENPRAU\MATLAB\Database\';
addpath(genpath('C:\Users\Kasper\Documents\GitHub\libsvm'));
addpath(pwd); % Add current folder to path

cd(MAIN_DIR);

toc;disp('Loading data and labels');

load('ProcessedData\targetLabel.mat');
% load('ProcessedData\dataMatrix.mat');
load('ProcessedData\dataPts');
dataMatrix = dataPts;
metaData = load('ProcessedData\g_warped_metaData.mat');
objectPixels = metaData.objectPixels;
clear('metaData');

nFrames = size(targetLabel,1);
nTargets = size(targetLabel,2)-1;

targetVector = cell(nTargets,1);

trainingTarget = cell(nTargets,1);
testTarget = cell(nTargets,1);
% idx:		1, 2, 3, 4,  5,  6,  7,  8,  9, 10, 11
% FACS AU:	4, 6, 7, 9, 10, 12, 20, 25, 26, 43, PSPI-score

%% Select frames randomly and set 20% aside for test
% nSel = 15000;
nSel = nFrames;
testFrac = floor(nSel*0.20);
% selData = randperm(nFrames,nSel);
selData = 1:nFrames;
testSel = selData(1:testFrac);
trainSel = selData(testFrac+1:end);

trainingData = dataMatrix(trainSel,:);
testData = dataMatrix(testSel,:);
clear('dataMatrix');

parfor facsLabelIdx = 1:nTargets

	targetVector{facsLabelIdx} = zeros(nFrames,1);

	for idx = 1:nFrames

		if targetLabel(idx,facsLabelIdx) >= 1

			targetVector{facsLabelIdx}(idx) = 1;

		else
			targetVector{facsLabelIdx}(idx) = -1;

		end

	end

	trainingTarget{facsLabelIdx} = targetVector{facsLabelIdx}(trainSel);
	testTarget{facsLabelIdx} = targetVector{facsLabelIdx}(testSel);

end



toc; disp('Start training');

libsvm_options = [
	'-s 0 ', ... C-SVC		(multi-class classification)
	'-t 0 ', ... 2 = RBF; 0 = Linear kernel
	'-b 1 ', ... Probability estimates
	'-q ',	 ... Quiet mode
	];

model = cell(nTargets,1);

predicted_label = cell(nTargets,1);
accuracy = cell(nTargets,1);
prob_estimates = cell(nTargets,1);


parfor targetIdx = 1:nTargets
	
	model{targetIdx} = svmtrain(trainingTarget{targetIdx}, trainingData , libsvm_options);

	% [predicted_label{targetIdx}, accuracy{targetIdx}, prob_estimates{targetIdx}] = ...
	% 	svmpredict(testTarget, testMatrix, model{targetIdx}, '-b 1');
	disp(['Model ', num2str(targetIdx), ' trained']);

end

toc;disp('All models trained');

figure(1)

for targetIdx = 1:nTargets

	[predicted_label{targetIdx}, accuracy{targetIdx}, prob_estimates{targetIdx}] = ...
		svmpredict(testTarget{targetIdx}, testData, model{targetIdx}, '-b 1');

	auc(targetIdx) = plotroc(testTarget{targetIdx}, testData, model{targetIdx});

	pause(1);

end

figure(2)
bar(auc);
title('Area Under Curve for each FACS AU')
xlabel('AU')
ylabel('AUC')


toc; disp('Finished!');

