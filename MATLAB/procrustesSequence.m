function [Z, Z0, d] = procrustesSequence(S,S0)

if nargin == 1

	S0 = S{1};

	n_iters = 2;

elseif nargin == 2

	n_iters = 1;

else
	error('Wrong number of input arguments');	

end

nFrames = size(S,2);

S1 = zeros([nFrames, size(S0)]);

for frame = 1:nFrames

	S1(frame,:,:) = S{frame};

end

Z = zeros(size(S1));

for i = 1:n_iters

	for frame = 1:nFrames 

		[d, Z(frame,:,:)] = procrustes(S0,squeeze(S1(frame,:,:)));

	end

	Z0 = squeeze(mean(Z));

	S0 = Z0;

	S1 = Z;

end

d = procrustes(S0,Z0);

Z = num2cell(Z,[2 3]);
Z = cellfun(@squeeze, Z, 'UniformOutput', false);