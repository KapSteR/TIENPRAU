clear; clc; tic;

disp('Init');

MAIN_DIR = 'D:\PainRecognotion_KasperNielsen_10731\Batch_runs\ViolaJonesPatchExtract\';
DATA_DIR = 'D:\PainRecognotion_KasperNielsen_10731\Database\';

cd(MAIN_DIR);

toc; disp('Load and sanitize dataset');
% load('facePatches.mat');
load('facePatchesWhite.mat');
% load('facePatchesWhite48.mat');
load('faceTargetLabel.mat');

% Use whitened data instead
facePatches = xZCAWhite;
clear('xZCAWhite');

% Remove blank face detections
facePatches(:,:,(facePatchesMetaData.errorIdx == 1)) = [];
targetLabel((facePatchesMetaData.errorIdx == 1),:) = [];
facePatchesMetaData.subject((facePatchesMetaData.errorIdx == 1)) = [];
facePatchesMetaData.errorIdx((facePatchesMetaData.errorIdx == 1)) = [];

% Make pspi target binary
painThreshold = 1; % Minimum score for pain
targetLabel = targetLabel(:,11); % Select pain (11) as target feature
targetLabel(targetLabel >= painThreshold) = 1;
targetLabel = targetLabel + 1;

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
nTest = numel(testIdx);

% Meta data labels
meta = struct;

meta.sets = cell(1,3);
meta.sets{1} = 'train';
meta.sets{1} = 'val';
meta.sets{1} = 'test';

meta.classes = cell(1,2);
meta.classes{1} = 'No pain';
meta.classes{2} = 'Pain';


% Image data structure
images = struct;

images.labels = targetLabel';
images.set = [ones(1, nTrainNew) , ones(1, nTest)*3];

images.data_mean = single(mean(facePatches,3));

images.data = single(zeros(size(facePatches,1), size(facePatches,2), 1, nTrain+nTest));

for idx = 1:nTrain+nTest

	images.data(:,:,1,idx) = single(facePatches(:,:,idx));

end

toc; disp('Saving to file');
save('data\second_try\imdb.mat', 'images', 'meta');

toc



