%% warpAppToMeanShape: function description
function [g_warped, x_vals, y_vals] = warpAppToMeanShape(I, Z, Z0, DT_Z0)
	%%% NOTE!: Consider doing something about input image

	% Image dimensions
	[R, C] = size(I);

	% Shape dimensions
	[n, m] = size(Z);

	if not(size(Z) == size(Z0))

		error('Z and Z0 not same size');

	end

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
	pixelLocation = zeros(R,C);
	
	idx = 1	;
	remove = [];
	for r = 1:R
		for c = 1:C

			pixelTraingle = DT_new.pointLocation(r, c);

			if not(isnan(pixelTraingle))

				[x, y] = affTrans{pixelTraingle}.transformPointsForward(r, c);
				newPixels(idx, 1) = x; 
				newPixels(idx, 2) = y;
				newPixels(idx, 3) = I(c,r); % REMEMBER: x-vals are col numbers, y-vals are row number

			else
				remove = [remove, idx];

			end


			idx = idx + 1;
		end
	end

	newPixels(remove,:) = [];

	
	% Interpolate pixels to fit image grid
	x_vals = floor(min(Z0(:,2))):ceil(max(Z0(:,2)));
	y_vals = floor(min(Z0(:,1))):ceil(max(Z0(:,1)));

	x_offset = min(x_vals);
	y_offset = min(y_vals);

	xyq = zeros(numel(x_vals)*numel(y_vals),2);

	inter = scatteredInterpolant(newPixels(:,1), newPixels(:,2), newPixels(:,3));
	inter.ExtrapolationMethod = 'none'



	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	%TODO :

	% Find list of pixel positions for mean shape mask
	% Evaluate image at these positios
		% Output to vector
	% Make zero matrix the size of image
	% Input values at pixel position in matrix
	% show as image




	g_warped = zeros(numel(x_vals), numel(y_vals));
	% g_warped = zeros(numel(x_vals) * numel(y_vals),1);

	idx = [1,1];
	% idx = 1;



	for r = x_vals
		for c = y_vals

			% xyq(idx,1) = r;
			% xyq(idx,2) = c;
			% idx = idx + 1;

			% g_warped(idx(1),idx(2)) = inter(r,c);
			% idx(2) = idx(2) + 1;
			g_warped(r-x_offset+1, c-y_offset+1) = inter(c,r);
		
		end
		idx(1) = idx(1) + 1;
		idx(2) = 1;
		idx(1)
	end

	% [xq,yq] = meshgrid(floor(min(Z0,1)):ceil(max(Z0,1)) , floor(min(Z0,2)):ceil(max(Z0,2))); % NOTE: Consider rescaleing here

	% g_warped = griddata(newPixels(:,1), newPixels(:,2), newPixels(:,3), xq, yq); 

	% g_warped = griddata(newPixels(:,1), newPixels(:,2), newPixels(:,3), xyq(:,1), xyq(:,2)); 

end
