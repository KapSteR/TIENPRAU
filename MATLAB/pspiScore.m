function [PSPI_score] = pspiScore(facs)

	% 1, 2, 3, 4,  5,  6,  7,  8,  9, 10
	% 4, 6, 7, 9, 10, 12, 20, 25, 26, 43

	PSPI_score = facs(1) + max([facs(2),facs(3)]) + max([facs(4), facs(5)]);

	if facs(10)
		PSPI_score = PSPI_score + 1;
	end

end