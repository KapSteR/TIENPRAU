function [Z, Z0] = procrustesBatch(S,S0)


% If no reference shape is given
if nargin == 1

	% Make reference shape the mean of all shapes
	S0 = meanShapeBatch(S);

	% Set number of iterations to two and adjust mean shape
	% Two chosen on recomendation from "DTU ph.d web page"
	n_iters = 2;

% If reference shape is given
elseif nargin == 2

	% Only run alignment once
	n_iters = 1;

else
	error('Wrong number of input arguments');	

end


for i = 1:n_iters

	% For all subjects in database
	for subject = 1:no_subjects

		% For all sequences pertaining to the subject
		for sequence = 1:metaData(subject).no_seq

			% For all frames in a sequence
			for frame = 1:metaData(subject).no_frames(sequence);

				Z{subject}{sequence}{frame} = procrustes(S{subject}{sequence}{frame}, S0);

			end
		end
	end

	Z0 = meanShapeBatch(Z);

	S = Z;

end

end