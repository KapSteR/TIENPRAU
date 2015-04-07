clear; clc; tic;

disp('Init');

MAIN_DIR = 'D:\PainRecognotion_KasperNielsen_10731\Batch_runs\ViolaJonesPatchExtract\';
DATA_DIR = 'D:\PainRecognotion_KasperNielsen_10731\Database\';

cd(MAIN_DIR);

toc; disp('Load and sanitize dataset');
load('facePatches.mat');
load('faceTargetLabel.mat');

% Remove blank face detections
facePatches(:,:,(facePatchesMetaData.errorIdx == 1)) = [];
targetLabel((facePatchesMetaData.errorIdx == 1),:) = [];
facePatchesMetaData.subject((facePatchesMetaData.errorIdx == 1)) = [];
facePatchesMetaData.errorIdx((facePatchesMetaData.errorIdx == 1)) = [];




toc; disp('Determine train/test set');
subjectSelect = 1;

testFrac = .20;

dataIdx = find(facePatchesMetaData.subject == subjectSelect);

nFrames = numel(dataIdx);

dataIdx = dataIdx(randperm(nFrames)); % Randomize order

testIdx = dataIdx(1:ceil(nFrames*testFrac));
trainIdx = dataIdx(ceil(nFrames*testFrac)+1:end);


% Adjust for batch size
batchSize = numel(trainIdx);
nTrain = numel(trainIdx);
nTrainNew = floor(nTrain/batchSize)*batchSize;

trainIdx = trainIdx(1:nTrainNew);

train_x = facePatches(:,:,trainIdx);
test_x = facePatches(:,:,testIdx);

% Make pspi target binary
targetLabel = targetLabel(:,11);
targetLabel(targetLabel>0) = 1;

train_y(1,:) = targetLabel(trainIdx);
train_y(2,:) = (train_y(1,:)-1) * -1;	% make 0 -> 1 ; 1 -> 0
test_y(1,:) = targetLabel(testIdx);
test_y(2,:) = (test_y(1,:)-1) * -1;		% make 0 -> 1 ; 1 -> 0


toc; disp('Initialize Neural Network');

rand('state',0) % Consider revising or removing

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
figure; plot(cnn.rL);
grid on
grid minor

endTime = toc;

save('thirdCNNrun.mat', 'cnn', 'er', 'bad', 'endTime')

toc; disp('Finished!');