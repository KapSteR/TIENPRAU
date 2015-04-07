figure(1);clf;

for i = 1:1000
	
	imshow(imageFromGreyVector(trainData{11}(i,:),objectPixels))
	
	if trainTarget{11}(i) == -1
		s = ' No Pain';
		
	elseif trainTarget{11}(i) == 1
		s = ' Pain';
	end
	title([num2str(i),s]);
	
	pause(0.5)
	
end