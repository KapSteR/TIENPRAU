clear; clc; tic;

disp('Init');

MAIN_DIR = 'C:\Users\Kasper\Documents\GitHub\TIENPRAU\MATLAB\';
DATA_DIR = 'C:\Users\Kasper\Documents\GitHub\TIENPRAU\MATLAB\Database\';
addpath(genpath('C:\Users\Kasper\Documents\GitHub\libsvm'));

% addpath(pwd); % Add current folder to path

cd(MAIN_DIR);

toc;disp('Loading and labels');

load('ProcessedData\targetLabel.mat');

nFrames = size(targetLabel,1);

targetVector = zeros(nFrames,1);

% facsLabelIdx = 10;
% % idx:		1, 2, 3, 4,  5,  6,  7,  8,  9, 10
% % FACS AU:	4, 6, 7, 9, 10, 12, 20, 25, 26, 43

% for idx = 1:nFrames

% 	if targetLabel(idx,facsLabelIdx)
% 		targetVector(idx) = 1;
% 	end

% end
targetVector = targetLabel(:,11);

clear('targetLabel');

toc;disp('Loading data');
% load('ProcessedData\dataMatrix.mat');
load('ProcessedData\dataPts');
dataMatrix = dataPts;
metaData = load('ProcessedData\g_warped_metaData.mat');
objectPixels = metaData.objectPixels;
clear('metaData');

% nSel = 5000;
nSel = nFrames;
testFrac = floor(nSel*0.20);
% selData = randperm(nFrames,nSel);
selData = 1:nFrames;
testSel = selData(1:testFrac);
trainSel = selData(testFrac+1:end);

% trainingData = dataMatrix(trainSel,:);
trainingData = dataMatrix(trainSel,:);
trainingTarget = targetVector(trainSel);

% testMatrix = dataMatrix(testSel,:);
testMatrix = dataMatrix(testSel,:);
testTarget = targetVector(testSel);

clear('dataMatrix');

toc; disp('Start training');
libsvm_options = [
	'-s 0 ', ... C-SVC		(multi-class classification)
	'-t 0 ', ... 2 = RBF; 0 = Linear kernel
	'-b 1 ', ... Probability estimates
	'-v 5 ', ... Cross-Validation
	];
	
model = svmtrain(trainingTarget, trainingData , libsvm_options);
 
toc; disp('Testing model');
[predicted_label, accuracy, prob_estimates] = svmpredict(testTarget, testMatrix, model, '-b 1');

predErrorIdx = find((testTarget == predicted_label)==0);
nError = size(predErrorIdx,1);

toc;disp('Displaying data');
figure(1)
clf
subplot(211)
stem(1:testFrac, testTarget)
hold on
stem(1:testFrac, predicted_label)
% plot(1:testFrac, prob_estimates(:,1))
xlim([1, testFrac])
subplot(212)
stem(predErrorIdx, ones(nError,1))
xlim([1, testFrac])
hold off

figure(2)
% imshow(imageFromGreyVector(testMatrix(predErrorIdx(1),:),objectPixels))


toc; disp('Finished!');