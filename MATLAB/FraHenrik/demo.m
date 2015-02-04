clear; clc;

MAIN_DIR = 'C:\Users\Kasper\Documents\GitHub\TIENPRAU\MATLAB\FraHenrik';
DATA_DIR = 'C:\Users\Kasper\Documents\GitHub\TIENPRAU\MATLAB\DataBase\';

% Read info about patients and video sequences.
read_meta_data;

% Play video sequence 3 for subject 2 with AAM landmarks displayed on top.
subject = 11;
sequence = 2;
play_sequence;