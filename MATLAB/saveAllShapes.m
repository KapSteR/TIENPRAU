clear; clc;
tic

DATA_DIR = 'C:\Users\Kasper\Documents\GitHub\TIENPRAU\MATLAB\DataBase\';

[no_subjects, metaData] = readMetaData(DATA_DIR);

disp('Init done');
toc

[S] = getShapesBatch(DATA_DIR, metaData, no_subjects);

save('AllShapesRaw.mat', 'S')

disp('All unaligned shapes saved');
toc

[Z, Z0] = procrustesBatch(S)

disp('All aligned shapes saved');
toc