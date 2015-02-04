function [Z, Z0 d] = procrustesBatch(S,S0)


% If no reference shape is given
if nargin == 1

	% Make reference shape the mean of all shapes
	S0 = cellfun(@mean, S);

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

	[d, Z] = cellfun(@procrustes, S, S0, 'UniformOutput', false);

	S = Z;

end

Z0 = cellfun(@mean, Z);

end