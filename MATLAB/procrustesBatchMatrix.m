function [Z, Z0] = procrustesBatchMatrix(S, S0)


% If no reference shape is given
if nargin == 1

	% Make reference shape the mean of all shapes
	% Z0 = meanShapeBatch(S, metaData, no_subjects);
	Z0 = mean(S,3)

	% Set number of iterations to two and adjust mean shape
	% Two chosen on recomendation from "DTU ph.d web page"
	n_iters = 1;

% If reference shape is given
elseif nargin == 3

	Z0 = S0;

	% Only run alignment once
	n_iters = 1;

else
	error('Wrong number of input arguments');	

end

Z = zeros(size(S));

for i = 1:n_iters

	% For all frames
	for idx = 1:size(S,3)

		[d, Z(idx)] = procrustes(Z0, S(idx));
	
	end

	Z0 = mean(Z,3)

	S = Z;

end

end