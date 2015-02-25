function  [Idir, metaData] = loadImagePathBatch(DATA_DIR, numFramesTotal)

% Load Images
OLD_DIR =  cd([DATA_DIR, 'Images']);

files           = dir;
subject_names   = {files(3:end).name};
nSubjects     = length(subject_names);

Idir = cell(numFramesTotal,3); % Fix this dependency on numFramesTotal
idx = 1;

% For all subjects in database
for subject = 1:nSubjects

	cd(subject_names{subject});
	files           = dir;
    sequence_names  = {files(3:end).name};
    nSequences    = length(sequence_names);

    % Save metadata
    metaData(subject).name      = subject_names{subject};
    metaData(subject).no_seq    = nSequences;
    metaData(subject).sequences = sequence_names;

	% For all sequences pertaining to the subject
	for sequence = 1:nSequences

		cd(sequence_names{sequence});
		files = dir;
		files = files(3:end);
		frame_names = {files.name};

		nFrames = length(frame_names);

		% For all frames in a sequence
		for frame = 1:nFrames;

		    filename = files(frame).name;
		    Idir{idx,1} = [
		    	metaData(subject).name, '\', ...
		    	metaData(subject).sequences{sequence}, '\', ...
		    	filename
		    	];

		    Idir{idx,2} = subject; % Subject identifier

		    Idir{idx,3} = sequence; % Sequence identifier

		    idx = idx + 1;

		end
		cd('..')
	end
	cd('..')
end

% Go back to original directory
cd(OLD_DIR);

end

