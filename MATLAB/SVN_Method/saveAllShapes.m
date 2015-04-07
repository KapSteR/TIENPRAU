clear; clc;
tic

DATA_DIR = 'D:\PainRecognotion_KasperNielsen_10731\Batch_runs\grey_vector_warping\DataBase\';

[no_subjects, metaData] = readMetaData(DATA_DIR);

disp('Init done');
toc

[S] = getShapesBatch(DATA_DIR, metaData, no_subjects);

save('AllShapesRaw.mat', 'S')

disp('All unaligned shapes saved');
toc

[Z, Z0] = procrustesBatch(S, metaData, no_subjects);

save('AllShapesAlign.mat', 'Z', 'Z0')

disp('All aligned shapes saved');
toc