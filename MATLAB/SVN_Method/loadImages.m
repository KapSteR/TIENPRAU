function  [I] = loadImages(DATA_DIR, metaData, subID, seqID)

% Load Images
OLD_DIR =  cd([DATA_DIR, '\Images']);

cd(metaData(subID).name);
cd(metaData(subID).sequences{seqID});

files = dir;
files = files(3:end);

for frame = 1:metaData(subID).no_frames(seqID);
    filename = files(frame).name;
    I{frame} = imread(filename);
end

cd(OLD_DIR)

end