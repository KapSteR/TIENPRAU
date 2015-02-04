function [ S ] = getShapeSequence( subID, seqID, DATA_DIR )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

OLD_DIR = cd(DATA_DIR);

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

cd(OLD_DIR);

end

