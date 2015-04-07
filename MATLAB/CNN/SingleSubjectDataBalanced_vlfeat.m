clear; clc; tic;

disp('Init');

MAIN_DIR = 'D:\PainRecognotion_KasperNielsen_10731\Batch_runs\ViolaJonesPatchExtract\';
DATA_DIR = 'D:\PainRecognotion_KasperNielsen_10731\Database\';

cd(MAIN_DIR);

toc; disp('Load and sanitize dataset');
load('facePatches.mat');
% load('facePatchesWhite.mat');
load('faceTargetLabel.mat');

% Use whitened data instead
% facePatches = xZCAWhite;
% clear('xZCAWhite');

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

subjectID = 1;

subjectIdx = find(facePatchesMetaData.subject == subjectID);

positiveIdx = find(targetLabel(subjectIdx) == 2);
positiveIdx = subjectIdx(positiveIdx);
negativeIdx = find(targetLabel(subjectIdx) == 1);
negativeIdx = subjectIdx(negativeIdx);


nPositive = numel(positiveIdx);
nNegative = numel(negativeIdx);

% If there is a large over representation of negatives
if nNegative > 1.5 *nPositive

	% Select subset of negatives the size of positives
	negativeIdx = negativeIdx(randperm(nNegative,nPositive));

	nNegative = nPositive;

end
dataIdx = [positiveIdx ; negativeIdx];
nTotal = numel(dataIdx);

% Adjust for batch size
batchSize = 100;
threshold = round((0.7/batchSize) * nTotal) * batchSize; %

randomIdx = randperm(nTotal);
trainIdx = randomIdx(1:threshold);
testIdx = randomIdx(threshold+1:end);

nTrain = numel(trainIdx);
nTest = numel(testIdx);

% Meta data labels
meta = struct;

meta.sets = cell(1,3);
meta.sets{1} = 'train';
meta.sets{2} = 'val';
meta.sets{3} = 'test';

meta.classes = cell(1,2);
meta.classes{1} = 'No pain';
meta.classes{2} = 'Pain';


% Image data structure
images = struct;

images.labels = targetLabel(randomIdx)';
% images.set = [ones(1, nTrainNew) , ones(1, nTest)*3];
images.set = ones(1,nTotal);
images.set(testIdx) = ones(1, nTest)*3;

images.data_mean = single(mean(facePatches(:,:,dataIdx),3));

images.data = single(zeros(size(facePatches,1), size(facePatches,2), 1, nTotal));

for i = 1:nTotal

	idx = randomIdx(i);
	images.data(:,:,1,i) = single(facePatches(:,:,idx));

end

toc; disp('Saving to file');
save('data\fourth_try\imdb.mat', 'images', 'meta');

toc



