function [ totalSum ] = sumAll( input )
%SUMALL Summary of this function goes here
%   Detailed explanation goes here
    
    for i = 1:1:size(size(input),2)
        input = sum(input);
    end
    totalSum = input;
end

