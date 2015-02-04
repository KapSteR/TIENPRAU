cd(DATA_DIR)
% Load AMM landmarks
cd('AAM_landmarks');
cd(info(subject).name);
cd(info(subject).sequences{sequence});
files = dir;
files = files(3:end);
for frame = 1:info(subject).no_frames(sequence);
    filename = files(frame).name;
    A{frame} = dlmread(filename);
end
cd(DATA_DIR);

% Load Images
cd('Images');
cd(info(subject).name);
cd(info(subject).sequences{sequence});
files = dir;
files = files(3:end);
for frame = 1:info(subject).no_frames(sequence);
    filename = files(frame).name;
    I{frame} = imread(filename);
end

% Display
for frame = 1:info(subject).no_frames(sequence);
    imshow(I{frame})
    hold on
    plot(A{frame}(:,1),A{frame}(:,2),'.')
    hold off
    pause(0.1)
end
cd(MAIN_DIR)
