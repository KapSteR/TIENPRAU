function [Z, Z0] = procrustesBatch(S, metaData, no_subjects, S0)


% If no reference shape is given
if nargin == 3

	% Make reference shape the mean of all shapes
	Z0 = meanShapeBatch(S, metaData, no_subjects);

	% Set number of iterations to two and adjust mean shape
	% Two chosen on recomendation from "DTU ph.d web page"
	n_iters = 2;

% If reference shape is given
elseif nargin == 4

	Z0 = S0;

	% Only run alignment once
	n_iters = 1;

else
	error('Wrong number of input arguments');	

end

Z = S;


for i = 1:n_iters

	% For all subjects in database
	for subject = 1:no_subjects

		% For all sequences pertaining to the subject
		for sequence = 1:metaData(subject).no_seq

			% For all frames in a sequence
			for frame = 1:metaData(subject).no_frames(sequence);

				[d, Z{subject}{sequence}{frame}] = procrustes(Z0, S{subject}{sequence}{frame});

			end
		end
	end

	Z0 = meanShapeBatch(Z, metaData, no_subjects);

	S = Z;

end

end