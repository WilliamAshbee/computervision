boxImage = imread('checkers6.jpg');
boxImage =rgb2gray(boxImage);

obj = VideoReader('h3vid_shortend.avi');
vid = read(obj);
  
 % read the total number of frames
frames = obj.NumberOfFrames;
  
% reading and writing the frames 
images = []
hold on
figure
for x = 1: frames
    % concatenating 2 strings
    Vid = vid(:, :, :, x);
    %cd frames
    disp(x)
    % exporting the frames
    %imshow(Vid);
    %cd ..  
    try
       f =  processFrame(Vid);
    catch
        disp('frame had an error')
    end
    pause(.1)
end


function frame = processFrame(sceneImage)
    global boxImage
    sceneImage = rgb2gray(sceneImage);
    
    boxPoints = detectSURFFeatures(boxImage);
    scenePoints = detectSURFFeatures(sceneImage);
    
    [boxFeatures, boxPoints] = extractFeatures(boxImage, boxPoints);
    [sceneFeatures, scenePoints] = extractFeatures(sceneImage, scenePoints);
    
    boxPairs = matchFeatures(boxFeatures, sceneFeatures);
    
    matchedBoxPoints = boxPoints(boxPairs(:, 1), :);
    matchedScenePoints = scenePoints(boxPairs(:, 2), :);
    
    [tform, inlierIdx] = ...
        estimateGeometricTransform2D(matchedBoxPoints, matchedScenePoints, 'affine');
    
    boxPolygon = [1, 1;...                           % top-left
            size(boxImage, 2), 1;...                 % top-right
            size(boxImage, 2), size(boxImage, 1);... % bottom-right
            1, size(boxImage, 1);...                 % bottom-left
            1, 1];                   % top-left again to close the polygon
    
    newBoxPolygon = transformPointsForward(tform, boxPolygon);
    
    %figure;
    frame = getframe(gcf);
    imshow(sceneImage);
    hold on;
    line(newBoxPolygon(:, 1), newBoxPolygon(:, 2), 'Color', 'y');
    title('Detected Box');
end