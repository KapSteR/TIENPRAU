function [S0] = meanShapeBatch = ( S )

sumShape = zeros(size(S{1}{1}{1}));
nShapes = 0;

% For all subjects in database
	for subject = 1:no_subjects

		% For all sequences pertaining to the subject
		for sequence = 1:metaData(subject).no_seq

			% For all frames in a sequence
			for frame = 1:metaData(subject).no_frames(sequence);

				sumShape = sumShape = S{subject}{sequence}{frame};
				N = N + 1;

			end
		end
	end
end

S0 = sumShape./nShapes;