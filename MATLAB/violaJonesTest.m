clear; clc; tic;

disp('Init');

MAIN_DIR = 'C:\Users\Kasper\Documents\GitHub\TIENPRAU\MATLAB\';
DATA_DIR = 'C:\Users\Kasper\Documents\GitHub\TIENPRAU\MATLAB\Database\';
addpath(genpath('C:\Users\Kasper\Documents\GitHub\libsvm'));
addpath(pwd); % Add current folder to path

cd(MAIN_DIR);


[Idir, metaData] = loadImagePathBatch(DATA_DIR,48398);
toc