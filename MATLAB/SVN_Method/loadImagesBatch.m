function  [I] = loadImagesBatch(DATA_DIR, metaData, no_subjects, numFramesTotal)

% Load Images
OLD_DIR =  cd([DATA_DIR, '\Images']);

I = cell(numFramesTotal,1);
idx = 1;

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
		    I{idx} = imread(filename);
		    idx = idx + 1;

		end
		cd('..')
	end
	cd('..')
end

% Go back to original directory
cd(OLD_DIR);

end

