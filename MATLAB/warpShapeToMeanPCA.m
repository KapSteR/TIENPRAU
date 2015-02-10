function [Zw, x_fit] = warpShapeToMeanPCA(Zv, Z0v, Evectors)
	% Function returns best approximation of warp to mean shape using PCA

	A = Evectors;

	b = Zv - Z0v;

	x_fit = inv(A'*A)*A'*b;

	Zw = A * x_fit + Z0v;

end