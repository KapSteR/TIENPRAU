%% leaveOneOutData: function description
function [imdb] = leaveOneOutData(leaveOutID)

	toc; disp('Load and sanitize dataset');
	load('facePatches.mat');
	load('faceTargetLabel.mat');

	% Remove blank face detections
	facePatches(:,:,(facePatchesMetaData.errorIdx == 1)) = [];
	targetLabel((facePatchesMetaData.errorIdx == 1),:) = [];
	facePatchesMetaData.subject((facePatchesMetaData.errorIdx == 1)) = [];
	facePatchesMetaData.errorIdx((facePatchesMetaData.errorIdx == 1)) = [];
	[rows, cols, nFrames] = size(facePatches);

	% Make pspi target binary
	painThreshold = 1; % Minimum score for pain
	targetLabel = targetLabel(:,11); % Select pain (11) as target feature
	targetLabel(targetLabel >= painThreshold) = 1;
	targetLabel = targetLabel + 1;

	toc; disp('Determine train/test set');
	leaveOutIdx = find(facePatchesMetaData.subject == leaveOutID);
	nLeaveOut = numel(leaveOutIdx);
	leaveInIdx = find(facePatchesMetaData.subject ~= leaveOutID);

	positiveIdx = find(targetLabel(leaveInIdx) == 2);
	positiveIdx = leaveInIdx(positiveIdx);
	negativeIdx = find(targetLabel(leaveInIdx) == 1);
	negativeIdx = leaveInIdx(negativeIdx);

	nPositive = numel(positiveIdx);
	nNegative = numel(negativeIdx);

	% If there is a large over representation of negatives
	if nNegative > 1.5 *nPositive

		% Select subset of negatives the size of positives
		negativeIdx = negativeIdx(randperm(nNegative,nPositive));

		nNegative = nPositive;

	end
	dataIdx = [positiveIdx ; negativeIdx];
	nTrain = numel(dataIdx);
	nTotal = nTrain + nLeaveOut;

	randomIdx = randperm(nTrain);


	% Meta data labels
	meta = struct;

	meta.sets = cell(1,3);
	meta.sets{1} = 'train';
	meta.sets{2} = 'val';
	meta.sets{3} = 'test';

	meta.classes = cell(1,2);
	meta.classes{1} = 'No pain';
	meta.classes{2} = 'Pain';

	toc; disp('Make images struct');
	% Image data structure
	images = struct;

	images.labels = [targetLabel(dataIdx(randomIdx))', targetLabel(leaveOutIdx)'];
	images.set = ones(1,nTotal);

	images.data_mean = single(mean(facePatches(:,:,dataIdx),3));
	
	% Make images 4D-matrix
	images.data = single(zeros(size(facePatches,1), size(facePatches,2), 1, nTotal));

	for i = 1:nTrain

		idx = randomIdx(i);
		images.data(:,:,1,i) = single(facePatches(:,:,idx));

	end

	for i = 1:nLeaveOut

		idx = leaveOutIdx(i);
		images.data(:,:,1,i+nTrain) = single(facePatches(:,:,idx));
		images.set(nTrain+i) = 3;

	end

	imdb = struct;
	imdb.images = images;
	imdb.meta = meta;

end