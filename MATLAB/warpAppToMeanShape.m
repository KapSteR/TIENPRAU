%% warpAppToMeanShape: function description
function [g_warped, object_pixels] = warpAppToMeanShape(I, Z, Z0)

	% Image dimensions
	[R, C] = size(I);

	% Shape dimensions
	[n, m] = size(Z);

	if not(size(Z) == size(Z0))

		error('Z and Z0 not same size');

	end

	



end
