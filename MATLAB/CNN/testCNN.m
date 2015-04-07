clear; clc; tic;

disp('Init');

MAIN_DIR = 'D:\PainRecognotion_KasperNielsen_10731\Batch_runs\ViolaJonesPatchExtract\';
DATA_DIR = 'D:\PainRecognotion_KasperNielsen_10731\Database\';

cd(MAIN_DIR);

toc; disp('Load and sanitize dataset');
% load('facePatches.mat');
load('facePatchesWhite.mat');
load('faceTargetLabel.mat');

% Use whitened data instead
facePatches = xZCAWhite;
clear('xZCAWhite');

% Remove blank face detections
facePatches(:,:,(facePatchesMetaData.errorIdx == 1)) = [];
targetLabel((facePatchesMetaData.errorIdx == 1),:) = [];
facePatchesMetaData.subject((facePatchesMetaData.errorIdx == 1)) = [];
facePatchesMetaData.errorIdx((facePatchesMetaData.errorIdx == 1)) = [];




toc; disp('Determine train/test set');
leaveOutSub = [21:25];

leaveInSub = [1:20];

trainIdx = [];
for i = 1:numel(leaveInSub)

	trainIdx = [trainIdx ; find(facePatchesMetaData.subject == leaveInSub(i))];

end

testIdx = [];
for i = 1:numel(leaveOutSub)

	testIdx = [testIdx ; find(facePatchesMetaData.subject == leaveOutSub(i))];

end

% Adjust for batch size
batchSize = 100;
nTrain = numel(trainIdx);
nTrainNew = floor(nTrain/batchSize)*batchSize;

trainIdx = trainIdx(1:nTrainNew);

train_x = facePatches(:,:,trainIdx);
test_x = facePatches(:,:,testIdx);

% Make pspi target binary
painThreshold = 1; % Minimum score for pain
targetLabel = targetLabel(:,11); % Select pain (11) as target feature
targetLabel(targetLabel >= painThreshold) = 1;

train_y(1,:) = targetLabel(trainIdx);
train_y(2,:) = (train_y(1,:)-1) * -1;	% make 0 -> 1 ; 1 -> 0
test_y(1,:) = targetLabel(testIdx);
test_y(2,:) = (test_y(1,:)-1) * -1;		% make 0 -> 1 ; 1 -> 0


toc; disp('Initialize Neural Network');

% rand('state',0) % Consider revising or removing

cnn.layers = {
    struct('type', 'i') %input layer
    struct('type', 'c', 'outputmaps', 25, 'kernelsize', 11) %convolution layer
    struct('type', 's', 'scale', 2) %sub sampling layer
    struct('type', 'c', 'outputmaps', 25, 'kernelsize', 8) %convolution layer
    struct('type', 's', 'scale', 2) %subsampling layer
};


opts.alpha = 1;
opts.batchsize = batchSize;
opts.numepochs = 5;

toc;disp('Start training and test');
cnn = cnnsetup(cnn, train_x, train_y);
cnn = cnntrain(cnn, train_x, train_y, opts);

[er, bad] = cnntest(cnn, test_x, test_y);

toc;disp('Do some plots');

%plot mean squared error
figure
plot(cnn.rL);
hold on
refline(0,(sum(test_y(1,:)/numel(test_y(1,:)))));
grid on
grid minor

endTime = toc;

save('fifthCNNrun.mat', 'cnn', 'er', 'bad', 'endTime')

toc; disp('Finished!');