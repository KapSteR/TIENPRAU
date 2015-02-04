clear; clc;

DATA_DIR = 'C:\Users\Kasper\Documents\GitHub\TIENPRAU\MATLAB\DataBase\';

[subject_names, no_subjects, metaData] = readMetaData(DATA_DIR);

subject = 1;

for sequence = 1:metaData(subject).no_seq

	S{sequence} = getShapeSequence(subject, sequence, DATA_DIR, metaData);

	Z{sequence} = procrustesSequence(S{sequence});
end

