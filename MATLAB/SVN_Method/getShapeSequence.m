function [ S ] = getShapeSequence( subID, seqID, DATA_DIR, metaData )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

OLD_DIR = cd(DATA_DIR);

% Load AMM landmarks
cd('AAM_landmarks');
cd(metaData(subID).name);
cd(metaData(subID).sequences{seqID});
files = dir;
files = files(3:end);

for frame = 1:metaData(subID).no_frames(seqID);
    filename = files(frame).name;
    S{frame} = dlmread(filename);
end

cd(OLD_DIR);

end

