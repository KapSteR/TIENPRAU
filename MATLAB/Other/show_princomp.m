function show_princomp(ShapeData,AppearanceData,TrainingData)

% Coordinates of mean contour
base_points = [ShapeData.x_mean(1:end/2) ShapeData.x_mean(end/2+1:end)];

% Normalize the base points to range 0..1
base_points = base_points - repmat(min(base_points),size(base_points,1),1);
base_points = base_points ./ repmat(max(base_points),size(base_points,1),1);

% Transform the mean contour points into the coordinates in the texture
% image.
base_points(:,1)=1+(ShapeData.TextureSize(1)-1)*base_points(:,1);
base_points(:,2)=1+(ShapeData.TextureSize(2)-1)*base_points(:,2);

% Draw the contour as one closed line white line and fill the resulting
% (hand) object
ObjectPixels= drawObject(base_points,ShapeData.TextureSize,TrainingData(1).Lines);
ObjectPixels=bwconvhull(ObjectPixels);

% Mean texture
I_mean=AAM_Vector2Appearance2D(AppearanceData.g_mean,AppearanceData.ObjectPixels,ShapeData.TextureSize);

% Loop through principal components
for i=1:size(ShapeData.Evectors,2)
    
    s=sqrt(ShapeData.Evalues(i))*3;
    range = linspace(-s,s,10);
    range = [ range fliplr(range) ];
    for j = 1:length(range)
        xtest(:,j) = ShapeData.x_mean + ShapeData.Evectors(:,i)*range(j);
    end
    ts = ceil(max(abs([max(xtest(:)) min(xtest(:))])))*2;
    xtest = xtest - min(xtest(:));
    xtest = xtest / max(xtest(:));
    xtest=1+(ts-1)*xtest;
    
    for j = 1:length(range)
        Vertices=[xtest(1:end/2,j) xtest(end/2+1:end,j)];
        Lines=[(1:size(Vertices,1))' ([2:size(Vertices,1) 1])'];
        ObjectPixels2 = drawObject(Vertices,[ts ts],Lines);
        ObjectPixels2 = bwconvhull(ObjectPixels2);
        g2 = AAM_Appearance2Vector2D(I_mean,base_points,Vertices,ObjectPixels2,[ts ts],ShapeData.Tri);
        I_texture = AAM_Vector2Appearance2D(g2,ObjectPixels2,[ts ts]);
        subplot(1,2,1),imshow(I_texture),
        subplot(1,2,2),imshow(I_texture),
        hold on
        plot(Vertices(:,2),Vertices(:,1),'.')
        hold off
        drawnow
    end
end


