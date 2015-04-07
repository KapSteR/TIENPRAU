clear; clc; tic;

MAIN_DIR = 'C:\Users\Kasper\Documents\GitHub\TIENPRAU\MATLAB\';
DATA_DIR = 'C:\Users\Kasper\Documents\GitHub\TIENPRAU\MATLAB\Database\';
% addpath(pwd); % Add current folder to path

cd(MAIN_DIR);

load('data\AllShapesRaw.mat')
load('data\AllShapesAlign.mat');

% Dimensions
[n, m, nFrames] = size(Z);

% Vectorize data
Zv = zeros(nFrames,n*m);

for idx = 1:nFrames

	Zv(idx,:) = [Z(:, 1, idx)' , Z(:, 2, idx)'];

end

Z0v = [ Z0(:,1)', Z0(:,2)' ];


% Principal Components Analysis
[Evectors,SCORE,Evalues] = princomp(Zv);

% % Keep only 98% of all eigen vectors, (remove contour noise)
% i=find(cumsum(Evalues)>sum(Evalues)*0.99,1,'first'); 
i = 4;
Evectors=Evectors(:,1:i);
Evalues=Evalues(1:i);


toc

% Find shape variation approximation with appropriate number of PCA components
for idx = 1:1%nFrames

	[Z_PCAv(idx,:), x_fit] = warpShapeToMeanPCA(Zv(idx,:), Z0v, Evectors);

end

% Devectorize data
Z_PCA = zeros(n, m, nFrames);
for idx = 1:1%nFrames

	Z_PCA(:,:,idx) = [Z_PCAv(idx,1:n)', Z_PCAv(idx, n+1:end)'];

end



% Make Delaunay triangulation of mean shape
DT_Z0 = delaunayTriangulation(Z0);

% Find pixels contained withing mean shape triangulaiton
x_vals = floor(min(Z0(:,2))):ceil(max(Z0(:,2)));
y_vals = floor(min(Z0(:,1))):ceil(max(Z0(:,1)));

objectPixels = [];

for c = x_vals
	for r = y_vals

		if not(isnan(DT_Z0.pointLocation(c,r)))
			objectPixels = [ objectPixels ; c, r ];
		end

	end
end


% Warp images to mean shape
for idx = 1:1%nFrames

	Idir = [DATA_DIR 'Images\042-ll042\ll042t1aaaff\ll042t1aaaff001.png'];
	I = imread(Idir);
	I = rgb2gray(I);
	I = double(I)./255;
	[g_warped, x_vals, y_vals] = warpAppToMeanShape(I, S(:,:,idx), Z0, DT_Z0);

end

toc


