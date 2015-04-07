%% warpAppToMeanShape: function description
function [g_warped] = warpAppToMeanShape(I, Z, DT_Z0, objectPixels)
	%%% NOTE!: Consider doing something about input image

	% Image dimensions
	[R, C] = size(I);

	% Number of output pixels
	nOutVector = size(objectPixels,1);

	DT_new = triangulation(DT_Z0.ConnectivityList, Z); % Make new triangulation based on mean 

	nTriangles = size(DT_Z0.ConnectivityList, 1);

	affTrans = cell(1,nTriangles);

	for idx = 1:nTriangles

		% Find triangles for transformation
		Tri1 = DT_Z0.ConnectivityList(idx,:);
		Tri1 = DT_Z0.Points(Tri1,:);

		Tri2 = DT_new.ConnectivityList(idx,:);
		Tri2 = DT_new.Points(Tri2,:);		

		% Make transformation matrix
		A = ([Tri1'; 1, 1, 1] / [Tri2'; 1, 1, 1])';
        A(:,3) = [ 0 0 1 ]';

		% Create affine transformation object
		affTrans{idx} = affine2d(A);

	end

	% Assign all pixels to a triangle and locate those outside triangulation
	% Perform affine transform of coordinates with respect to the individual triangle
	
	newPixels = zeros(R*C, 3); % One row for each pixel, a column each for x, y, value
	
	idx = 1	;
	nRemove = 0;
	remove = zeros(R*C,1);
	for r = 1:R
		for c = 1:C

			pixelTraingle = DT_new.pointLocation(r, c);

			if not(isnan(pixelTraingle))

				[x, y] = affTrans{pixelTraingle}.transformPointsForward(r, c);
				newPixels(idx, 1) = x; 
				newPixels(idx, 2) = y;
				newPixels(idx, 3) = I(c,r); % REMEMBER: x-vals are col numbers, y-vals are row number

			else
				remove(nRemove +1 ) = idx;
				nRemove = nRemove + 1;

			end

			idx = idx + 1;
		end
	end

	newPixels(remove(1:nRemove),:) = [];

	
	% Interpolate pixels to fit image grid
	inter = scatteredInterpolant(newPixels(:,1), newPixels(:,2), newPixels(:,3));
	inter.ExtrapolationMethod = 'linear';

	g_warped = zeros(nOutVector, 1);

	for idx = 1:nOutVector

		g_warped(idx) = inter(objectPixels(idx,:));

	end

end
