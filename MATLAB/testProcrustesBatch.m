clear; clc;
tic

DATA_DIR = 'C:\Users\Kasper\Documents\GitHub\TIENPRAU\MATLAB\DataBase\';

[no_subjects, metaData] = readMetaData(DATA_DIR);

load('AllShapesRaw');
load('AllShapesAlign');

disp('Init done');
toc

subject = 2;
sequence = 3;

I = loadImages(DATA_DIR, metaData, subject, sequence);

disp('Load image done');
toc

% Display
figure(1)
% pause
for frame = 1:metaData(subject).no_frames(sequence);
	subplot(1,2,1)
    imshow(I{frame})
    hold on
    plot(S{subject}{sequence}{frame}(:,1),S{subject}{sequence}{frame}(:,2),'.')
    hold off

    subplot(1,2,2)
    plot(Z{subject}{sequence}{frame}(:,1),Z{subject}{sequence}{frame}(:,2)*-1,'*') % Multiply by -1 to invert axis to fit image
    xlim([0 320])
    ylim([-240 -0])
    % pause(0.1)
    drawnow
end

disp('Done');
toc

