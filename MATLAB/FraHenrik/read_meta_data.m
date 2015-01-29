
cd(MAIN_DIR);
cd('Frame_Labels\FACS\');

files           = dir;
subject_names   = {files(3:end).name};
no_subjects     = length(subject_names);

for subject = 1:no_subjects
    
    cd(subject_names{subject});
    files           = dir;
    sequence_names  = {files(3:end).name};
    no_sequences    = length(sequence_names);
    
    info(subject).name      = subject_names{subject};
    info(subject).no_seq    = no_sequences;
    info(subject).sequences = sequence_names;
    
    for sequence = 1:no_sequences
        cd(sequence_names{sequence});
        files = dir;
        files = files(3:end);
        frames_names = {files.name};
        no_frames = length(frames_names);
        info(subject).no_frames(sequence) = no_frames;
        cd('..');
    end
    cd('..');
end
cd(MAIN_DIR);
