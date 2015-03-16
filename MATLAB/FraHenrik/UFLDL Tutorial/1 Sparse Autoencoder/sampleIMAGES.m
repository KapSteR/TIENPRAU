function patches = sampleIMAGES()
% sampleIMAGES
% Returns 10000 patches for training


data1 = load('data_batch_1.mat'); 
data2 = load('data_batch_2.mat'); 
data3 = load('data_batch_3.mat'); 
data4 = load('data_batch_4.mat'); 
data5 = load('data_batch_5.mat');
label1 = 3;
label2 = 9;
data = struct('images',0,'labels',0);
data.images = data1.data((data1.labels == label1) | (data1.labels == label2),:);
data.labels = data1.labels((data1.labels == label1) | (data1.labels == label2));
data.images = [data.images; data2.data((data2.labels == label1) | (data2.labels == label2),:)];
data.labels = [data.labels; data2.labels((data2.labels == label1) | (data2.labels == label2))];
data.images = [data.images; data3.data((data3.labels == label1) | (data3.labels == label2),:)];
data.labels = [data.labels; data3.labels((data3.labels == label1) | (data3.labels == label2))];
data.images = [data.images; data4.data((data4.labels == label1) | (data4.labels == label2),:)];
data.labels = [data.labels; data4.labels((data4.labels == label1) | (data4.labels == label2))];
data.images = [data.images; data5.data((data5.labels == label1) | (data5.labels == label2),:)];
data.labels = [data.labels; data5.labels((data5.labels == label1) | (data5.labels == label2))];

patchsize = 5;  % we'll use 5x5 patches 
numpatches = 5000; %change this to take more random patches
imgHeight = 32;
imWidth = 32;
imColorlayers = 3;
numberOfImages = size(data.images,1);

% Initialize patches with zeros.  Your code will fill in this matrix--one
% column per patch, 10000 columns. 
patches = zeros(patchsize^2*imColorlayers, numpatches);
RandomImages = randi(numberOfImages,numpatches,1);
RandomPatches = randi(imgHeight-patchsize,numpatches,2);

RandomList = [RandomImages RandomPatches];

for i = 1:numpatches
    img = data.images(RandomImages(i),:);
    img = reshape(img,imgHeight,imWidth,imColorlayers);
    Patch = img(RandomList(i,2):RandomList(i,2)+patchsize-1,RandomList(i,3):RandomList(i,3)+patchsize-1,:);
    Patch = reshape(Patch,size(patches,1),1);

    patches(:,i) = Patch;
end

 

%% ---------------------------------------------------------------
% For the autoencoder to work well we need to normalize the data
% Specifically, since the output of the network is bounded between [0,1]
% (due to the sigmoid activation function), we have to make sure 
% the range of pixel values is also bounded between [0,1]
patches = normalizeData(patches);

end


%% ---------------------------------------------------------------
function patches = normalizeData(patches)

% Squash data to [0.1, 0.9] since we use sigmoid as the activation
% function in the output layer

% Remove DC (mean of images). 
patches = bsxfun(@minus, patches, mean(patches));

% Truncate to +/-3 standard deviations and scale to -1 to 1
pstd = 3 * std(patches(:));
patches = max(min(patches, pstd), -pstd) / pstd;

% Rescale from [-1,1] to [0.1,0.9]
patches = (patches + 1) * 0.4 + 0.1;

end
