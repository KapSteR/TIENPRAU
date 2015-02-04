function [ S ] = getShapeSequence( subID, seqID )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

DATA_DIR = 'C:\Users\Kasper\Documents\GitHub\TIENPRAU\MATLAB\DataBase\';

MAIN_DIR = cd(DATA_DIR);

% Load AMM landmarks
cd('AAM_landmarks');
cd(info(subID).name);
cd(info(subID).sequences{seqID});
files = dir;
files = files(3:end);

for frame = 1:info(subID).no_frames(sequence);
    filename = files(frame).name;s
    A{frame} = dlmread(filename);
end

cd(MAIN_DIR);

end

