clear; clc;

load('data\warped_vectors\g_warped_metaData.mat');

g_warped = cell(nFrames,1);
errorIdx = cell(nFrames,1);


[g_warped2, errorIdx] = load('data\warped_vectors\g_warped2.mat');

[g_start, g_end] = [0,7100];

g_warped{g_start:g_end} = g_warped1{g_start:g_end};
errorIdx{g_start:g_end} = errorIdx{g_start:g_end};

clear('g_warped2', 'errorIdx');


[g_warped3, errorIdx] = load('data\warped_vectors\g_warped3.mat');

[g_start, g_end] = [7101,10000];

g_warped{g_start:g_end} = g_warped3{g_start:g_end};
errorIdx{g_start:g_end} = errorIdx{g_start:g_end};

clear('g_warped3', 'errorIdx');


[g_warped4, errorIdx] = load('data\warped_vectors\g_warped4.mat');

[g_start, g_end] = [10001, 12000];

g_warped{g_start:g_end} = g_warped4{g_start:g_end};
errorIdx{g_start:g_end} = errorIdx{g_start:g_end};

clear('g_warped4', 'errorIdx');


[g_warped5, errorIdx] = load('data\warped_vectors\g_warped5.mat');

[g_start, g_end] = [12001, 16000];

g_warped{g_start:g_end} = g_warped5{g_start:g_end};
errorIdx{g_start:g_end} = errorIdx{g_start:g_end};

clear('g_warped5', 'errorIdx');


[g_warped6, errorIdx] = load('data\warped_vectors\g_warped6.mat');

[g_start, g_end] = [16001, 25000];

g_warped{g_start:g_end} = g_warped6{g_start:g_end};
errorIdx{g_start:g_end} = errorIdx{g_start:g_end};

clear('g_warped6', 'errorIdx');


[g_warped7, errorIdx] = load('data\warped_vectors\g_warped7.mat');

[g_start, g_end] = [25001, 30000];

g_warped{g_start:g_end} = g_warped7{g_start:g_end};
errorIdx{g_start:g_end} = errorIdx{g_start:g_end};

clear('g_warped7', 'errorIdx');


[g_warped8, errorIdx] = load('data\warped_vectors\g_warped8.mat');

[g_start, g_end] = [30001;nFrames];

g_warped{g_start:g_end} = g_warped8{g_start:g_end};
errorIdx{g_start:g_end} = errorIdx{g_start:g_end};

clear('g_warped8', 'errorIdx');

save('ProcessedData\g_warped_total.mat', 'g_warped', 'errorIdx');