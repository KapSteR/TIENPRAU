clear; clc; tic;

disp('Init');

MAIN_DIR = 'D:\PainRecognotion_KasperNielsen_10731\Batch_runs\grey_vector_warping\';
DATA_DIR = 'D:\PainRecognotion_KasperNielsen_10731\Database\';
% addpath(pwd); % Add current folder to path

cd(MAIN_DIR);

toc; disp('Loading Shapes');

load('data\AllShapesRaw.mat')
load('data\AllShapesAlign.mat');

% Shape Dimensions
[n, m, nFrames] = size(Z);

% Load paths to images
toc; disp('Loading Image Paths');
% [no_subjects, metaData] = readMetaData(DATA_DIR);
% [Idir] = loadImagePathBatch(DATA_DIR, metaData, no_subjects, nFrames);
[I, metaData, nSubjects] = loadImagePathBatch(DATA_DIR, nFrames);


% Make Delaunay triangulation of mean shape
toc; disp('Triangulaiton Mean Shape');
DT_Z0 = delaunayTriangulation(Z0);


% Find pixels contained withing mean shape triangulaiton
toc; disp('Determining objectPixels');
x_vals = floor(min(Z0(:,2))):ceil(max(Z0(:,2)));
y_vals = floor(min(Z0(:,1))):ceil(max(Z0(:,1)));

objectPixels = zeros(numel(x_vals)*numel(y_vals),2);

% For each pixel in bounding box of mean shape
	% Determine if pixel is inside shape (pointLoacation != NaN)
	% Ap errpend coordinates inside shape to objectPixels array

nGrayVec = 0;
for c = x_vals
	for r = y_vals

		if not(isnan(DT_Z0.pointLocation(c,r)))
			objectPixels(nGrayVec + 1,:) = [ c, r ];
			nGrayVec = nGrayVec + 1;
		end

	end
end

objectPixels = objectPixels(1:nGrayVec,:);

save('data\warped_vectors\g_warped_metaData.mat', 'DT_Z0', 'objectPixels', 'nFrames','x_vals', 'y_vals');
% load('data\warped_vectors\g_warped_metaData.mat');

% g_warped = zeros(nFrames, size(objectPixels, 1));
g_warped = cell(nFrames,1);
errorIdx = cell(nFrames,1);




m = matfile('data\warped_vectors\g_warped.mat','Writable',true);

% Warp images to mean shape
toc; disp('Warping Images');

nIters = 1000;
% idxList = randperm(nFrames,nIters);

% for i = 0:50
% for i = 51:70
% for i = 71:99
% for i = 100:119
% for i = 120:159
% for i = 160:250
% for i = 251:299
for i = 0:47 % final

	parfor idx = (i*nIters)+1:(i+1)*nIters
	% parfor idx = 30001:nFrames

		% idx = idxList(i);

		Image = imread([DATA_DIR, 'Images\', I{idx,1}]);
		Image = rgb2gray(Image);
		Image = double(Image)./255;
		% g_warped(idx,:) = warpAppToMeanShape(I, S(:,:,idx), DT_Z0, objectPixels);

		try
			g_warped{idx} = warpAppToMeanShape(Image, S(:,:,idx), DT_Z0, objectPixels);

		catch err

			errorIdx{idx} = err;
			disp(['Error at image: ' num2str(idx)]);
			disp(err.message);

		end

		% disp(['Image ' , num2str(idx), ' of ', num2str(nFrames), ': Done']);

	end
	
	toc; disp(['Image ' , num2str((i+1)*nIters), ' of ', num2str(nFrames), ': Done']);

	% % Save to .mat-file
	% save(['data\warped_vectors\g_warped', num2str(i), '.mat'], 'g_warped', 'errorIdx');




	% % Clear memory
	% g_warped = cell(nFrames,1);
	% errorIdx = cell(nFrames,1);

end

idxMiddle = 48001;

parfor idx =idxMiddle:nFrames

	% idx = idxList(i);

	Image = imread([DATA_DIR, 'Images\', I{idx,1}]);
	Image = rgb2gray(Image);
	Image = double(Image)./255;
	% g_warped(idx,:) = warpAppToMeanShape(I, S(:,:,idx), DT_Z0, objectPixels);

	try
		g_warped{idx} = warpAppToMeanShape(Image, S(:,:,idx), DT_Z0, objectPixels);

	catch err

		errorIdx{idx} = err;

	end

	% disp(['Image ' , num2str(idx), ' of ', num2str(nFrames), ': Done']);

end


% Save to .mat-file
% save(['data\warped_vectors\g_warped', '48', '.mat'], 'g_warped', 'errorIdx');

g_warpedMetaData = struct;
g_warpedMetaData.errorIdx = errorIdx;
g_warpedMetaData.subject = cell2mat(I(:,2));
save('g_warped.mat', 'g_warped', 'g_warpedMetaData');


toc; disp('Finished!');




