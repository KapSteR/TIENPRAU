clear; clc; tic;

disp('Init');

MAIN_DIR = 'C:\Users\Kasper\Documents\GitHub\TIENPRAU\MATLAB\';
DATA_DIR = 'C:\Users\Kasper\Documents\GitHub\TIENPRAU\MATLAB\Database\';
% addpath(pwd); % Add current folder to path

cd(MAIN_DIR);

toc; disp('Loading Shapes');

load('data\AllShapesRaw.mat')
load('data\AllShapesAlign.mat');

% Shape Dimensions
[n, m, nFrames] = size(Z);

% Load paths to images
toc; disp('Loading Image Paths');
[no_subjects, metaData] = readMetaData(DATA_DIR);
[Idir] = loadImagePathBatch(DATA_DIR, metaData, no_subjects, nFrames);


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

save('data\warped_vectors\g_warped_metaData.mat', 'DT_Z0', 'objectPixels', 'nFrames','x_vals', 'y_vals')

% g_warped = zeros(nFrames, size(objectPixels, 1));
g_warped = cell(nFrames,1);
errorIdx = cell(nFrames,1);

% Warp images to mean shape
toc; disp('Warping Images');

nIters = 100;
% idxList = randperm(nFrames,nIters);

for i = 0:79

	parfor idx = (i*nIters)+1:(i+1)*nIters

		% idx = idxList(i);

		% Idir = [DATA_DIR 'Images\042-ll042\ll042t1aaaff\ll042t1aaaff001.png'];
		I = imread([DATA_DIR, 'Images\', Idir{idx}]);
		I = rgb2gray(I);
		I = double(I)./255;
		% g_warped(idx,:) = warpAppToMeanShape(I, S(:,:,idx), DT_Z0, objectPixels);

		try
			g_warped{idx} = warpAppToMeanShape(I, S(:,:,idx), DT_Z0, objectPixels);

		catch err

			errorIdx{idx} = err;

		end

	end
	toc; disp(['Image ' , num2str((i+1)*nIters), ' of ', num2str(nFrames), ': Done']);
	% save('data\warped_vectors\g_warped.mat', 'g_warped');

end

disp('Finished!');

toc


