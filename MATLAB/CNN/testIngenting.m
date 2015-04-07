clear; clc

load('data\third_try\imdb.mat');
% load('D:\PainRecognotion_KasperNielsen_10731\matconvnet-1.0-beta9\examples\data\mnist-baseline\imdb.mat');


[r,c,~,N] = size(images.data);

zeroMeanImages = images.data-repmat(images.data_mean,1,1,1,N);

figure(1)
for idx = 1:N

	% imshow(images.data(:,:,1,idx));
 	% imagesc(images.data(:,:,1,idx));
 	% imshow(zeroMeanImages(:,:,1,idx));
	imagesc(zeroMeanImages(:,:,1,idx));
	title(['Image: ', num2str(idx), ' | Label: ', num2str(images.labels(idx))]);

 	% drawnow
	pause(0.05)

end
