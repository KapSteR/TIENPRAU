clear; clc;
tic

DATA_DIR = 'C:\Users\Kasper\Documents\GitHub\TIENPRAU\MATLAB\DataBase\';

[no_subjects, metaData] = readMetaData(DATA_DIR);

subject = 2;

disp('Init done');
toc

for sequence = 1:metaData(subject).no_seq

	S{sequence} = getShapeSequence(subject, sequence, DATA_DIR, metaData);

	Z{sequence} = procrustesSequence(S{sequence});
end

disp('Procustes done');
toc

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
    plot(S{sequence}{frame}(:,1),S{sequence}{frame}(:,2),'.')
    hold off

    subplot(1,2,2)
    plot(Z{sequence}{frame}(:,1),Z{sequence}{frame}(:,2)*-1,'*') % Multiply by -1 to invert axis to fit image
    xlim([0 320])
    ylim([-240 -0])
    % pause(0.1)
    drawnow
end

disp('Done');
toc

