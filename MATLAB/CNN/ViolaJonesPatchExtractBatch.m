clear; clc; tic;

disp('Init');

MAIN_DIR = 'D:\PainRecognotion_KasperNielsen_10731\Batch_runs\ViolaJonesPatchExtract\';
DATA_DIR = 'D:\PainRecognotion_KasperNielsen_10731\Database\';

cd(MAIN_DIR);

nFrames = 48398; % Fix this

toc;disp('Load image paths');
[I, metaData, nSubjects] = loadImagePathBatch(DATA_DIR, nFrames);

% Make Viola-Jones detector object
faceDetector = vision.CascadeObjectDetector('FrontalFaceCART');
faceDetector.MinSize = [100, 100]; % Limit false detection (see Sub: 23) and increase speed

toc; disp('Detect faces');

% figure(1)

% subID = 20;

% idxStart = min(find(cell2mat(Idir(:,2)) == subID ));
% idxEnd = max(find(cell2mat(Idir(:,2)) == subID ));

% patchSize = [100, 100];
patchSize = [48, 48]; 	% Smaller size for faster processing
						% High factor number for better fractions

facePatches = zeros([patchSize,nFrames]);
errorIdx = zeros(nFrames,1);


for idx = 1:nFrames
	
	I_in = imread([DATA_DIR, 'Images\', I.dir{idx}]);
	
	bbox = step(faceDetector, I_in);
	
	try
		x1 = bbox(1,1);
		y1 = bbox(1,2);
		x2 = x1 + bbox(1,3);
		y2 = y1 + bbox(1,4);

	catch
		errorIdx(idx) = true;
		continue;
		
	end
	
	% Extract patch
	Ipatch = I_in(y1:y2,x1:x2,:);
	
	% convert to gray scale
	Ipatch = rgb2gray(Ipatch);
	
	% Rescale to common patch size and save to data matrix
	facePatches(:,:,idx) = imresize(Ipatch, patchSize);
	
	if mod(idx,1000) == 0
		toc; disp([num2str(idx), ' of ', num2str(nFrames), 'images processed']);
	end
	
end

facePatchesMetaData = struct('errorIdx',errorIdx,'subject',I.subject);

save('facePatches48.mat', 'facePatches', 'facePatchesMetaData');





toc; disp('Finished!');

