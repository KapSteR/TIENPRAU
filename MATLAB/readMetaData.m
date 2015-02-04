function [no_subjects, metaData] = readMetaData(DATA_DIR)

OLD_DIR = cd([DATA_DIR, 'Frame_Labels\FACS\']);

files           = dir;
subject_names   = {files(3:end).name};
no_subjects     = length(subject_names);

for subject = 1:no_subjects
    
    cd(subject_names{subject});
    files           = dir;
    sequence_names  = {files(3:end).name};
    no_sequences    = length(sequence_names);
    
    metaData(subject).name      = subject_names{subject};
    metaData(subject).no_seq    = no_sequences;
    metaData(subject).sequences = sequence_names;
    
    for sequence = 1:no_sequences
        cd(sequence_names{sequence});
        files = dir;
        files = files(3:end);
        frames_names = {files.name};
        no_frames = length(frames_names);
        metaData(subject).no_frames(sequence) = no_frames;
        cd('..');
    end
    cd('..');
end

cd(OLD_DIR);
