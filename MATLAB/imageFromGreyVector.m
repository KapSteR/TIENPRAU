function [I] = imageFromGreyVector(g_vector, objectPixels)

	x_min = min(objectPixels(:,1));
	x_max = max(objectPixels(:,1));

	y_min = min(objectPixels(:,2));
	y_max = max(objectPixels(:,2));

	R = y_max-y_min;
	C = x_max-x_min;

	I = zeros(R,C)

	nObjectPixels = size(objectPixels,1);

	for idx = 1:nObjectPixels

		I(objectPixels(idx,1)+y_min, objectPixels(idx,2)+x_min) = g_vector(idx);

	end

end