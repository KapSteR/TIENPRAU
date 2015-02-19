clear;clc;

load('ProcessedData\g_warped_total.mat');
load('ProcessedData\g_warped_metaData.mat')

load('ProcessedData\AllShapesAlign.mat');

% load('ProcessedData\targetData.mat');

dataVector = cell(nFrames,3);
% target = cell(nFrames,1);

remove = [];

for i = 1:nFrames

	if isempty(errorIdx(i))

		dataVector{i,1} = g_warped{i};
		dataVector{i,2} = Z(i,1,:);
		dataVector{i,3} = Z(i,2,:);
		% target{i} = targetData;

	else
		remove = [remove ; i];

	end

end

% Remove cell with erroneous data;
dataVector{remove,:} = []; 
% target{remove} = [];


dataMatrix = cell2mat(dataVector);
% targetVector = cell2mat(target);

nFrames_total = size(dataMatrix,1);

save('ProcessedData\dataMatrix.mat', 'dataMatrix', 'nFrames_total');
% save('ProcessedData\targetVector', 'targetVector');



