clear;clc;tic;

load('ProcessedData\g_warped_total.mat');
load('ProcessedData\g_warped_metaData.mat')

load('ProcessedData\AllShapesAlign.mat');
toc
dataVector = cell(nFrames,3);

remove = [];

for i = 1:nFrames

	if isempty(errorIdx{i})

		dataVector{i,1} = g_warped{i}';	% Gray vector
		dataVector{i,2} = Z(:,1,i)';		% x-coordinates
		dataVector{i,3} = Z(:,2,i)';		% y-coordinates
		% target{i} = targetData;

	else
		remove = [remove ; i];

	end
end
toc
clear('g_warped', 'errorIdx', 'Z');

% Remove cell with erroneous data;
dataVector(remove,:) = []; 

nFrames_total = size(dataVector,1);

lDatum = size(dataVector{1,1},2) + size(dataVector{1,2},2) + size(dataVector{1,3},2);

% dataMatrixTemp = zeros(10000,lDatum);

dataMatrixTemp1 = cell2mat(dataVector(1:10000,:));

save('data\dataMatrixTemp1.mat', 'dataMatrixTemp1');

clear('dataMatrixTemp1');
toc

dataMatrixTemp2 = cell2mat(dataVector(10001:20000,:));

save('data\dataMatrixTemp2.mat', 'dataMatrixTemp2');

clear('dataMatrixTemp2');


dataMatrixTemp3 = cell2mat(dataVector(20001:end,:));

save('data\dataMatrixTemp3.mat', 'dataMatrixTemp3');

clear('dataMatrixTemp3', 'dataVector');
toc
load('data\dataMatrixTemp1');
load('data\dataMatrixTemp2');

dataMatrix = [
	dataMatrixTemp1 ;
	dataMatrixTemp2
	];

clear('dataMatrixTemp1', 'dataMatrixTemp2');
toc
load('data\dataMatrixTemp3');

dataMatrix = [ 
	dataMatrix ;
	dataMatrixTemp3
	];

save('ProcessedData\dataMatrix.mat', 'dataMatrix', 'nFrames_total');
% save('ProcessedData\targetVector', 'targetVector');
toc



