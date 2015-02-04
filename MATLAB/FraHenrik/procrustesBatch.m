function [Z, Z0 d] = procrustesBatch(S,S0)

if nargin == 1

	S0 = S{1};

	n_iters = 2;

elseif nargin == 2

	n_iters = 1;

else
	error('Wrong number of input arguments');	

end





end