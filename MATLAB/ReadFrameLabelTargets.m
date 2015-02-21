clear; clc; tic;

disp('Init');

MAIN_DIR = 'C:\Users\Kasper\Documents\GitHub\TIENPRAU\MATLAB\';
DATA_DIR = 'C:\Users\Kasper\Documents\GitHub\TIENPRAU\MATLAB\Database\';
% addpath(pwd); % Add current folder to path

cd(MAIN_DIR);

toc; disp('Loading label paths');
load('ProcessedData\errorIdx.mat');
nFrames = size(errorIdx,1);
[no_subjects, metaData] = readMetaData(DATA_DIR);
labelDir = loadImagePathBatch(DATA_DIR, metaData, no_subjects, nFrames);

targetLabel = zeros(nFrames,11);
remove = [];

toc; disp('Start fetching labels');

for idx = 1:nFrames

	% Try/Catch in case file is empty
	try
		labels = dlmread([DATA_DIR, 'Frame_Labels\FACS\', labelDir{idx}],'\t');

		for i = 1:size(labels,1);

			switch labels(i,1)
				case 4
					targetLabel(idx,1) = labels(i,2);

				case 6
					targetLabel(idx,2) = labels(i,2);

				case 7
					targetLabel(idx,3) = labels(i,2);

				case 9
					targetLabel(idx,4) = labels(i,2);

				case 10
					targetLabel(idx,5) = labels(i,2);

				case 12
					targetLabel(idx,6) = labels(i,2);

				case 20
					targetLabel(idx,7) = labels(i,2);

				case 25
					targetLabel(idx,8) = labels(i,2);

				case 26
					targetLabel(idx,9) = labels(i,2);

				case 43
					targetLabel(idx,10) = labels(i,2);

			end
		end

		targetLabel(idx,11) = pspiScore(targetLabel(idx,1:10));


	catch err
		if	(strcmp(err.identifier, 'MATLAB:textscan:EmptyFormatString')) 
			
			% targetLabel(idx,:) = cell(1,11); % Check dimensions

		else
			rethrow(err);
		end
	end

	if not(isempty(errorIdx{idx}))
		
		remove = [remove, idx];

	end
	
	
	if (mod(idx,1000) == 0)
		toc; disp([num2str(idx), ' of ' num2str(nFrames) ': Done']);
	end
end

targetLabel(remove,:) = [];

save('ProcessedData\targetLabel.mat');

toc; disp('Finished!');