function [I] = imageFromGreyVector(g_vector, objectPixels)

	%% NOTE: Check for inversion of y-coordinates
	x_min = min(objectPixels(:,1));
	x_max = max(objectPixels(:,1));

	y_min = min(objectPixels(:,2));
	y_max = max(objectPixels(:,2));

	R = y_max-y_min;
	C = x_max-x_min;

	I = zeros(R,C);

	nObjectPixels = size(objectPixels,1);

	for idx = 1:nObjectPixels

		I(objectPixels(idx,2)-y_min+1, objectPixels(idx,1)-x_min+1) = g_vector(idx);

	end

end