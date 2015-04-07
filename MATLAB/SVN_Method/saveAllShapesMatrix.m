clear; clc;
tic

MAIN_DIR = 'D:\PainRecognotion_KasperNielsen_10731\Batch_runs\grey_vector_warping\';
DATA_DIR = 'D:\PainRecognotion_KasperNielsen_10731\Batch_runs\grey_vector_warping\DataBase\';
cd(MAIN_DIR);

[no_subjects, metaData] = readMetaData(DATA_DIR);

disp('Init done');
toc

[S, numFramesTotal] = getShapesBatchMatrix(DATA_DIR, metaData, no_subjects );

save('data\AllShapesRaw.mat', 'S')

disp('All unaligned shapes saved');
toc

[Z, Z0] = procrustesBatchMatrix(S);

save('data\AllShapesAlign.mat', 'Z', 'Z0')

disp('All aligned shapes saved');
toc