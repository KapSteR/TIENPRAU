%% warpAppToMeanShape: function description
function [g_warped, object_pixels] = warpAppToMeanShape(I, Z, DT_Z0)

	% Image dimensions
	[R, C] = size(I);

	% Shape dimensions
	[n, m] = size(Z);

	if not(size(Z) == size(Z0))

		error('Z and Z0 not same size');

	end

	DT_new = triangulation(DT_Z0.Constraints, Z); % Make new triangulation based on mean 

	for

	nTriangles = size(DT_Z0.ConnectivityList, 1);

	affTrans = ell(1,nTriangles);

	for idx = 1:nTriangles

		% Find triangles for transformation
		Tri1 = DT_Z0.ConnectivityList(idx,:);
		Tri2 = DT_new.ConnectivityList(idx,:);

		% Make transformation matrix
		A = [; 1, 1, 1] / [Z; 1, 1, 1];

		% Create affine transformation object
		affTrans{idx} = affine2d(A);

	end

	% Assign all pixels to a triangle and locate those outside triangulation
	g_warped = zeros(R*C, 3); % One row for each pixel, a column each for x, y, value
	pixelLocation = zeros(R,C);
	idx = 1	
	for r = 1:R
		for c = 1:C

			pixelTraingle = DT_new.pointLocation(r, c);

			if not(pixelTraingle == NaN)

				g_warped(idx, [1:2]) = affTrans{pixelTraingle}.transformPointsForward(r, c);
				g_warped(idx, 3) = I(r,c);

			end
			idx = idx + 1;
		end
	end

	

	for







end
