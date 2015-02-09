clear all;

MAIN_DIR = 'C:\Users\Kasper\Documents\GitHub\TIENPRAU\MATLAB\';
DATA_DIR = 'C:\Users\Kasper\Documents\GitHub\TIENPRAU\MATLAB\Database';
addpath(pwd);

cd(DATA_DIR);
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
cd(DATA_DIR);

% Load AMM landmarks
cd('AAM_landmarks');
ix = 1;
for subject = 1 %:length(info)
    subject
    cd(info(subject).name);
    for sequence = 1 %:info(subject).no_seq
        cd(info(subject).sequences{sequence})
        files = dir;
        files = files(3:end);
        for frame = 1:60:length(files) %info(subject).no_frames(sequence);
            filename = files(frame).name;
            xy = dlmread(filename);
            A(:,ix) = xy(:);
            ix = ix + 1;
        end
        cd('..')
    end
    cd('..')
end
cd('..')

% Load Images
clear I
cd('Images');
ix = 1;
for subject = 1 %:length(info)
    cd(info(subject).name);
    for sequence = 1 %:info(subject).no_seq
        cd(info(subject).sequences{sequence})
        files = dir;
        files = files(3:end);
        for frame = 1:60:length(files) %info(subject).no_frames(sequence);
            filename = files(frame).name;
            I{ix} = imread(filename);
            ix = ix + 1;
        end
    end
end

% AMM
amm_path = 'C:\Users\Kasper\Documents\MATLAB\Toolboxes\ActiveModels_version7';
addpath(genpath(amm_path));

cd([MAIN_DIR 'data']);
for i = 1:10
    p.y = A(1:66,i)';
    p.x = A(67:end,i)';
    p.n = 66;
    p.t = zeros(1,66);
    p.I = double(I{i})/255;
    save(['dat' num2str(i) '.mat'],'p');
end

%% Set options
% Number of contour points interpolated between the major landmarks.
options.ni=2;
% Set normal appearance/contour, limit to +- m*sqrt( eigenvalue )
options.m=3;
% Size of appearance texture as amount of orignal image
options.texturesize=1;
% If verbose is true all debug images will be shown.
options.verbose=false;%true;
% Number of image scales
options.nscales=4;
% Number of search itterations
options.nsearch=15;

%% Load training data
% First Load the Hand Training DataSets (Contour and Image)
% The LoadDataSetNiceContour, not only reads the contour points, but
% also resamples them to get a nice uniform spacing, between the important
% landmark contour points.
TrainingData=struct;
for i=1:10
    filename=['dat' num2str(i) '.mat'];
    [TrainingData(i).Vertices, TrainingData(i).Lines]=LoadDataSetNiceContour(filename,options.ni,options.verbose);
    TrainingData(i).I=double(I{i})/255;
    
    if(options.verbose)
        Vertices=TrainingData(i).Vertices;
        Lines=TrainingData(i).Lines;
        t=mod(i-1,4); 
        if(t==0)
            figure
        end

        subplot(2,2,t+1)
        imshow(TrainingData(i).I)
        hold on;
        P1=Vertices(Lines(:,1),:)
        P2=Vertices(Lines(:,2),:);
        plot([P1(:,2) P2(:,2)]',[P1(:,1) P2(:,1)]','b');
        drawnow;

    end 
end

Data=cell(1,4);
for scale=1:options.nscales
    %% Shape Model %%
    % Make the Shape model, which finds the variations between contours
    % in the training data sets. And makes a PCA model describing normal
    % contours
    [ShapeData,TrainingData] = AAM_MakeShapeModel2D(TrainingData,options);
    
    % Show some eigenvector variations
    if(options.verbose)
        figure,
        for i=1:size(ShapeData.Evectors,2)
            xtest = ShapeData.x_mean + ShapeData.Evectors(:,i)*sqrt(ShapeData.Evalues(i))*3;
            subplot(2,3,i), hold on;
            plot(xtest(end/2+1:end),xtest(1:end/2),'r.');
            plot(ShapeData.x_mean(end/2+1:end),ShapeData.x_mean(1:end/2),'b.');
            axis equal
        end
    end
    
    %% Appearance model %%
    % Piecewise linear image transformation is used to align all texture
    % information inside the object (hand), to the mean handshape.
    % After transformation of all trainingdata textures to the same shape
    % PCA is used to describe the mean and variances of the object texture.
    AppearanceData=AAM_MakeAppearanceModel2D(TrainingData,ShapeData,options);
    
    % Show some appearance mean and eigenvectors
    if(options.verbose)
        figure,
        I_texture=AAM_Vector2Appearance2D(AppearanceData.g_mean,AppearanceData.ObjectPixels,ShapeData.TextureSize);
        subplot(2,2,1),imshow(I_texture,[]); title('mean grey');
        % I_texture=AAM_Vector2Appearance2D(AppearanceData.Evectors(:,1),AppearanceData.ObjectPixels,ShapeData.TextureSize);
        % subplot(2,2,2),show_norm_image(I_texture); title('first eigenv');
        % I_texture=AAM_Vector2Appearance2D(AppearanceData.Evectors(:,2),AppearanceData.ObjectPixels,ShapeData.TextureSize);
        % subplot(2,2,3),show_norm_image(I_texture); title('second eigenv');
        % I_texture=AAM_Vector2Appearance2D(AppearanceData.Evectors(:,3),AppearanceData.ObjectPixels,ShapeData.TextureSize);
        % subplot(2,2,4),show_norm_image(I_texture); title('third eigenv');
    end
    
     Data=warp_to_mean_shape(TrainingData,ShapeData,AppearanceData,options);
     for iter = 1:50
         for i = 1:10
             subplot(1,2,1),imshow(TrainingData(i).I)
             subplot(1,2,2),imshow(Data.I(:,:,:,i));
             drawnow;
         end;
     end
     
end
