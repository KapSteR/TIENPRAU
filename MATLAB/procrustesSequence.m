function [Z] = procrustesSequence(S,S0)

if nargin == 1

	S0 = S{1}{1};

	e_stop = 0.1;

elseif nargin == 2

	e_stop = inf;

else
	error('Wrong number of input arguments');	

end

nFrames = size(S,2);

while e >= e_stop

	for frame = 1:nFrames 

		Z{frame} = procrustes(S0,S{frame})

	end

	Z0 = mean(Z);

	e = procrustes(S0,Z0);

	S0 = Z0;

	S = Z;

end