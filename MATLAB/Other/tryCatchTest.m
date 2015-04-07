clear; clc;

errorIdx = cell(10,1);

result = cell(10,1);

parfor i = 1:10
	
	try
		
		result{i} = [1;1,1];
		
	catch err
		
		errorIdx{i} = err
	end
end