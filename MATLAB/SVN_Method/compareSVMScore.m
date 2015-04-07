clear; 
clc; tic;

disp('Init');

MAIN_DIR = 'D:\PainRecognotion_KasperNielsen_10731\Batch_runs\grey_vector_warping\';
DATA_DIR = 'D:\PainRecognotion_KasperNielsen_10731\Batch_runs\grey_vector_warping\Database\';
addpath(genpath('D:\PainRecognotion_KasperNielsen_10731\libsvm-3.20'));

cd(MAIN_DIR);
addpath(pwd); % Add current folder to path

toc;disp('Loading data and labels');

load('data\targetLabel.mat');
% load('ProcessedData\dataMatrix.mat');
load('data\dataMatrix.mat');

m = matfile('data\g_warped.mat');
g_warped_metaData = m.g_warpedMetaData;

nFrames = nFrames_total;
nTargets = size(targetLabel,2)-1; % Exclude pain
nSubjects = 25;

targetVector = cell(nTargets,1);

trainingTarget = cell(nTargets,1);
testTarget = cell(nTargets,1);
% idx:		1, 2, 3, 4,  5,  6,  7,  8,  9, 10, 11
% FACS AU:	4, 6, 7, 9, 10, 12, 20, 25, 26, 43, PSPI-score

remove = [];
for i = 1:numel(g_warped_metaData.errorIdx)
	
	if ~isempty(g_warped_metaData.errorIdx{i})
		remove = [remove, i];
	end
end

g_warped_metaData.subject(remove) = [];


leaveOutSubject = [1,8];
trainSel = [];
testSel = [];

for subIdx = 1:nSubjects

	if ismember(subIdx,leaveOutSubject)

		testSel = [testSel; find(g_warped_metaData.subject(:) == subIdx)];

	else

		trainSel = [trainSel; find(g_warped_metaData.subject(:) == subIdx)];

	end
end

%S-PTS
% trainingData = dataMatrix(trainSel,end-132+1:end);
% testData = dataMatrix(testSel,end-132+1:end);

% C-APP
trainingData = dataMatrix(trainSel,1:end-132);
testData = dataMatrix(testSel,1:end-132);

%S-PTS + C-APP / Full
% trainingData = dataMatrix(trainSel,1:end);
% testData = dataMatrix(testSel,1:end);

clear('dataMatrix')

trainData = cell(nTargets,1);

for facsLabelIdx = 1:nTargets

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

	modelTrainSelPos = find(trainingTarget{facsLabelIdx} == 1);
	nPositive = numel(modelTrainSelPos);

	modelTrainSelNeg = find(trainingTarget{facsLabelIdx} == -1);
	nNegative = numel(modelTrainSelNeg);

	if nPositive < nNegative

		modelTrainSelNeg = modelTrainSelNeg(randperm(nNegative,nPositive));
		nNegative = nPositive;

	end
	
	nTrainTotal = nPositive + nNegative;

	dataIdx = [modelTrainSelPos ; modelTrainSelNeg];

	dataIdx = dataIdx(randperm(numel(dataIdx)));

	trainTarget{facsLabelIdx} = trainingTarget{facsLabelIdx}(dataIdx);

	trainData{facsLabelIdx} = trainingData(dataIdx,:);

end

% Debug
% % lol = zeros(2,numel(testTarget));
% % lol(1,:) = 1:10;
% % for i = 1:numel(testTarget)
% % lol(2,i) = sum(testTarget{i})+numel(testTarget{i});
% % end
% % lol
% % toc
% debug end

clear('trainingData');
clear('trainingTarget');



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
	
	model{targetIdx} = svmtrain(trainTarget{targetIdx}, trainData{targetIdx} , libsvm_options);

	% [predicted_label{targetIdx}, accuracy{targetIdx}, prob_estimates{targetIdx}] = ...
	% 	svmpredict(testTarget, testMatrix, model{targetIdx}, '-b 1');
% 	toc; 
	disp(['Model ', num2str(targetIdx), ' trained']);

end

toc;disp('All models trained');

%%
figure(1)

auc = ones(nTargets,1)*-Inf;

parfor targetIdx = 1:nTargets

% 	[predicted_label{targetIdx}, accuracy{targetIdx}, prob_estimates{targetIdx}] = ...
% 		svmpredict(testTarget{targetIdx}, testData, model{targetIdx}, '-b 1');

	auc(targetIdx) = plotroc(testTarget{targetIdx}, testData, model{targetIdx});

	% pause(1);

end

figure(2)
h = bar(auc);
title('Area Under Curve for each FACS AU')
xlabel('FACS Action Unit')
ylabel('AUC')
ylim([0 1])
set(gca,'XtickLabel',...
	{'4', '6', '7', '9', '10', '12', '20', '25', '26', '43'})


save('data\compareSVMresultsAppBalanced.mat');

toc; disp('Finished!');

