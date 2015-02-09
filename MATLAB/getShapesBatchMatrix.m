function [ A, numFramesTotal ] = getShapesBatchMatrix( DATA_DIR, metaData, no_subjects )
%UNTITLED2 Summary of this function goes here
% 	Load AMM landmarks

% Jump to landmarks directory
OLD_DIR = cd([DATA_DIR, '\AAM_landmarks']);

numFramesTotal = 0;

% For all subjects in database
for subject = 1:no_subjects

	cd(metaData(subject).name);

	% For all sequences pertaining to the subject
	for sequence = 1:metaData(subject).no_seq

		cd(metaData(subject).sequences{sequence});
		files = dir;
		files = files(3:end);

		nFrames = metaData(subject).no_frames(sequence);

		% For all frames in a sequence
		for frame = 1:nFrames;
		    filename = files(frame).name;
		    S{subject}{sequence}{frame} = dlmread(filename);
		end

		numFramesTotal = numFramesTotal + nFrames

		cd('..')
	end
	cd('..')
end

A = zeros([size(S{1}{1}{1}), numFramesTotal]);
idx = 1;

for subject = 1:numel(S)

	% For all sequences pertaining to the subject
	for sequence = 1:numel(S{subject})

		% For all frames in a sequence
		for frame = 1:numel(S{subject}{sequence})

			A(:,:,idx) = S{subject}{sequence}{frame};
			idx = idx + 1;

		end
	end
end

% Go back to original directory
cd(OLD_DIR);

end

