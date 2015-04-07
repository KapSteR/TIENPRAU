clear;clc;tic;

MAIN_DIR = 'D:\PainRecognotion_KasperNielsen_10731\Batch_runs\grey_vector_warping\';
DATA_DIR = 'D:\PainRecognotion_KasperNielsen_10731\Batch_runs\grey_vector_warping\Database\';
% addpath(pwd); % Add current folder to path

cd(MAIN_DIR);

load('data\g_warped.mat');
load('data\targetLabel.mat')

load('data\AllShapesAlign.mat');

toc
nFrames = size(targetLabel,1);
dataVector = cell(nFrames,3);

remove = [];

for i = 1:nFrames

	if isempty(g_warpedMetaData.errorIdx{i})

		dataVector{i,1} = g_warped{i}';	% Gray vector
		dataVector{i,2} = Z(:,1,i)';		% x-coordinates
		dataVector{i,3} = Z(:,2,i)';		% y-coordinates
		% target{i} = targetData;

	else
		remove = [remove ; i];

	end
end
toc


% Remove cell with erroneous data;
dataVector(remove,:) = []; 
subject = g_warpedMetaData.subject;
subject(remove) = [];
targetLabel(remove,:) = [];

dataMatrix = cell2mat(dataVector);

nFrames_total = size(dataVector,1);


g_warpedData = struct;
g_warpedData.dataMatrix = dataMatrix;
g_warpedData.targetLabel = targetLabel;
g_warpedData.subject = subject;

save('data\dataMatrix.mat', 'dataMatrix', 'nFrames_total');

message = 'Finished!';

toc;fprintf('%s\n', message);