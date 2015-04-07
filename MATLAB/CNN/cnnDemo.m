clear; clc; tic;

% load('data\third_try\net-epoch-5000.mat');
% load('D:\PainRecognotion_KasperNielsen_10731\Batch_runs\ViolaJonesPatchExtract\data\leaveOneOut1\net-epoch-8.mat')
load('D:\PainRecognotion_KasperNielsen_10731\Batch_runs\ViolaJonesPatchExtract\data\leaveOneOut10\net-epoch-338.mat')


toc; disp('Load and sanitize dataset');
load('facePatches.mat');
% load('facePatchesWhite.mat');
load('faceTargetLabel.mat');

% Remove blank face detections
facePatches(:,:,(facePatchesMetaData.errorIdx == 1)) = [];
targetLabel((facePatchesMetaData.errorIdx == 1),:) = [];
facePatchesMetaData.subject((facePatchesMetaData.errorIdx == 1)) = [];
facePatchesMetaData.errorIdx((facePatchesMetaData.errorIdx == 1)) = [];

% Make pspi target binary
painThreshold = 1; % Minimum score for pain
targetLabel = targetLabel(:,11); % Select pain (11) as target feature
targetLabel(targetLabel >= painThreshold) = 1;
targetLabel = targetLabel + 1;


toc; disp('Determine train/test set');

% subjectID = 10;
errVec = zeros(25,1);

for subjectID = 11%1:25 %10
	
	subjectIdx = find(facePatchesMetaData.subject == subjectID);
	
	[R,C,~] = size(facePatches);
	nFrames = numel(subjectIdx);
	
	x = single(zeros(R,C,1,nFrames));
	labels = single(zeros(1,nFrames));
	
	for idx = 1:nFrames
		
		x(:,:,1,idx) = single(facePatches(:,:,subjectIdx(idx)));
		labels(idx) = targetLabel(subjectIdx(idx));
		
	end
	
	res = [];
	net.layers{end}.class = labels ;
	res = vl_simplenn(net, x, [], res);
	
	
	scores = gather(res(end-1).x) ;
	sz = size(scores) ;
	n = prod(sz(1:2)) ;
	
	scoreSum = squeeze(sum(sum(scores)));
	scoreDiff = scoreSum(1,:)-scoreSum(2,:);
	% [ bestScore , best ] = min(scoreSum);
% 	scoreDiff = scoreDiff-mean(scoreDiff);
	best = sign(scoreDiff);
	% bestOffset = (best-1.5)*2;
	bestOffset = best;
	labelsOffset = (labels-1.5)*2;
	
	confLabels = labels-1;
	confBest = (best+1)/2;
	
	
	error = labelsOffset ~= bestOffset;
	error = sum(error)/numel(error);
	errVec(subjectID) = error;
	
	
	figure
	plot(squeeze(bestOffset*50))
	hold on
	plot(labelsOffset*40)
	plot(scoreDiff)
	hold off
	% ylim([-0.2, 2.2])
	xlim([0 nFrames])
	xlabel('Frames')
	grid on
	grid minor
	legend('Best','Labels','Diff','Location','southeast')
	h = refline([0,0]);
	h.Color = 'k';
	h.LineStyle = '--';
	titleString = ['Subject: ', num2str(subjectID), ' | Error: ', num2str(error*100),'%'];
	title(titleString)
	drawnow
	
% 	plotconfusion(confLabels,confBest)
% 	[C, order] = confusionmat(labelsOffset,best)

	toc;disp(titleString)
	
end



% h = line([1 1],[-100 100])
% colormap('gray')
% 
% for i = 1:size(x,4)
% 	figure(2)
% 	imagesc(squeeze(x(:,:,1,i)))
% 	title(['Frame: ',num2str(i),' | Label: ',num2str(confLabels(i)),' Output: ',num2str(confBest(i))])
% 	set(h,'Xdata',[i i]);
% 	pause(0.5)
% end

