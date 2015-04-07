function [ S ] = getShapesBatch( DATA_DIR, metaData, no_subjects )
%UNTITLED2 Summary of this function goes here
% 	Load AMM landmarks

% Jump to landmarks directory
OLD_DIR = cd([DATA_DIR, '\AAM_landmarks']);


% For all subjects in database
for subject = 1:no_subjects

	cd(metaData(subject).name);

	% For all sequences pertaining to the subject
	for sequence = 1:metaData(subject).no_seq

		cd(metaData(subject).sequences{sequence});
		files = dir;
		files = files(3:end);

		% For all frames in a sequence
		for frame = 1:metaData(subject).no_frames(sequence);
		    filename = files(frame).name;
		    S{subject}{sequence}{frame} = dlmread(filename);
		end
		cd('..')
	end
	cd('..')
end

% Go back to original directory
cd(OLD_DIR);

end

