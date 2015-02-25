clear; clc; tic;

disp('Init');

MAIN_DIR = 'C:\Users\Kasper\Documents\GitHub\TIENPRAU\MATLAB\';
DATA_DIR = 'C:\Users\Kasper\Documents\GitHub\TIENPRAU\MATLAB\Database\';
addpath(genpath('C:\Users\Kasper\Documents\GitHub\libsvm'));
addpath(pwd); % Add current folder to path

cd(MAIN_DIR);

nFrames = 48398; % Fix this 

toc;disp('Load image paths');
[Idir, metaData, nSubjects] = loadImagePathBatch(DATA_DIR, nFrames);

% Make Viola-Jones detector object
faceDetector = vision.CascadeObjectDetector('FrontalFaceCART');
faceDetector.MinSize = [100, 100]; % Limit false detection (see Sub: 23) and increase speed

toc; disp('Detect faces');

subID = 20;

idx = find(cell2mat(Idir(:,2)) == subID ); 

for i = 1:size(idx,1)

	I = imread([DATA_DIR, 'Images\', Idir{idx(i),1}]);

	bboxes = step(faceDetector, I);

	IFaces = insertObjectAnnotation(I, 'rectangle', bboxes, 'Face');
	
	figure(1)
	imshow(IFaces)
	title([
		'Subject: ', ...
		num2str(subID), ...
		' | Sequence: ', ...
		num2str(Idir{idx(i),3}), ...
		' of ', ...
		num2str(metaData(subID).no_seq) ...
		]);

	drawnow;

end





toc; disp('Finished!');