function [Z_PCAv, x_fit] = warpShapeToMeanPCA(Zv, Z0v, Evectors)
	% Function returns best approximation of warp to mean shape using PCA

	Z0v = Z0v';

	A = Evectors;

	b = Zv' - Z0v;

	x_fit = inv(A'*A)*A'*b;

	Z_PCAv = (A * x_fit + Z0v)';

end