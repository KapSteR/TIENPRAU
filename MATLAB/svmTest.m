clear; clc; tic;

disp('Init');

MAIN_DIR = 'C:\Users\Kasper\Documents\GitHub\TIENPRAU\MATLAB\';
DATA_DIR = 'C:\Users\Kasper\Documents\GitHub\TIENPRAU\MATLAB\Database\';
% addpath(pwd); % Add current folder to path

cd(MAIN_DIR);

toc;disp('Loading and labels');

load('ProcessedData\targetLabel.mat');

nFrames = size(targetLabel,1);

targetVector = zeros(nFrames,1);

for idx = 1:nFrames

	if targetLabel(idx,1)
		targetVector(idx) = 1;
	end

end

clear('targetLabel');

toc;disp('Loading data');
load('ProcessedData\dataMatrix.mat');

nSel = 5000;
testFrac = floor(nSel*0.20);
selData = randperm(nFrames,nSel);
testSel = selData(1:testFrac);
trainSel = selData(testFrac+1:end);

trainingData = dataMatrix(trainSel,:);
trainingTarget = targetVector(trainSel);

testMatrix = dataMatrix(testSel,:);
testTarget = targetVector(testSel);

clear('dataMatrix');

toc; disp('Start training');
libsvm_options = [
	'-s 0 ', ... C-SVC		(multi-class classification)
	'-t 2 ', ... RBF kernel
	'-b 1 ', ... Probability estimates
	];
	
model = svmtrain(trainingTarget, trainingData , libsvm_options);

[predicted_label, accuracy, prob_estimates] = svmpredict(testTarget, testMatrix, model, '-b 1');

figure(1)
clf
subplot(211)
stem(1:testFrac, testTarget)
hold on
% stem(1:testFrac, predicted_label)
% stem(1:testFrac, predicted_label)
% plot(1:testFrac, prob_estimates(:,1))
subplot(212)
plot(1:testFrac, (testTarget == predicted_label))
hold off


toc; disp('Finished!');