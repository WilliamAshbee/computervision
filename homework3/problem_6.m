%boxImage = imread('stapleRemover.jpg');
boxImage = imread('checkers6.jpg');
boxImage =rgb2gray(boxImage);

figure;
imshow(boxImage);
title('Image of a Box');
sceneImage = imread('testimage6.jpg');
sceneImage = rgb2gray(sceneImage);
figure;
imshow(sceneImage);
title('Image of a Cluttered Scene');

boxPoints = detectSURFFeatures(boxImage);
scenePoints = detectSURFFeatures(sceneImage);

figure;
imshow(boxImage);
title('100 Strongest Feature Points from Box Image');
hold on;
plot(selectStrongest(boxPoints, 100));


figure;
imshow(sceneImage);
title('300 Strongest Feature Points from Scene Image');
hold on;
plot(selectStrongest(scenePoints, 300));

[boxFeatures, boxPoints] = extractFeatures(boxImage, boxPoints);
[sceneFeatures, scenePoints] = extractFeatures(sceneImage, scenePoints);

boxPairs = matchFeatures(boxFeatures, sceneFeatures);


matchedBoxPoints = boxPoints(boxPairs(:, 1), :);
matchedScenePoints = scenePoints(boxPairs(:, 2), :);
figure;
showMatchedFeatures(boxImage, sceneImage, matchedBoxPoints, ...
    matchedScenePoints, 'montage');
title('Putatively Matched Points (Including Outliers)');


[tform, inlierIdx] = ...
    estimateGeometricTransform2D(matchedBoxPoints, matchedScenePoints, 'affine');
inlierBoxPoints   = matchedBoxPoints(inlierIdx, :);
inlierScenePoints = matchedScenePoints(inlierIdx, :);


figure;
showMatchedFeatures(boxImage, sceneImage, inlierBoxPoints, ...
    inlierScenePoints, 'montage');
title('Matched Points (Inliers Only)');

boxPolygon = [1, 1;...                           % top-left
        size(boxImage, 2), 1;...                 % top-right
        size(boxImage, 2), size(boxImage, 1);... % bottom-right
        1, size(boxImage, 1);...                 % bottom-left
        1, 1];                   % top-left again to close the polygon

newBoxPolygon = transformPointsForward(tform, boxPolygon);

figure;
imshow(sceneImage);
hold on;
line(newBoxPolygon(:, 1), newBoxPolygon(:, 2), 'Color', 'y');
title('Detected Box');

% elephantImage = imread('elephant.jpg');
% figure;
% imshow(elephantImage);
% title('Image of an Elephant');
% 
% elephantPoints = detectSURFFeatures(elephantImage);
% figure;
% imshow(elephantImage);
% hold on;
% plot(selectStrongest(elephantPoints, 100));
% title('100 Strongest Feature Points from Elephant Image');
% 
% [elephantFeatures, elephantPoints] = extractFeatures(elephantImage, elephantPoints);
% 
% elephantPairs = matchFeatures(elephantFeatures, sceneFeatures, 'MaxRatio', 0.9);
% 
% 
% matchedElephantPoints = elephantPoints(elephantPairs(:, 1), :);
% matchedScenePoints = scenePoints(elephantPairs(:, 2), :);
% figure;
% showMatchedFeatures(elephantImage, sceneImage, matchedElephantPoints, ...
%     matchedScenePoints, 'montage');
% title('Putatively Matched Points (Including Outliers)');
% 
% [tform, inlierElephantPoints, inlierScenePoints] = ...
%     estimateGeometricTransform(matchedElephantPoints, matchedScenePoints, 'affine');
% figure;
% showMatchedFeatures(elephantImage, sceneImage, inlierElephantPoints, ...
%     inlierScenePoints, 'montage');
% title('Matched Points (Inliers Only)');
% 
% 
% elephantPolygon = [1, 1;...                                 % top-left
%         size(elephantImage, 2), 1;...                       % top-right
%         size(elephantImage, 2), size(elephantImage, 1);...  % bottom-right
%         1, size(elephantImage, 1);...                       % bottom-left
%         1,1];                         % top-left again to close the polygon
% 
% newElephantPolygon = transformPointsForward(tform, elephantPolygon);
% 
% figure;
% imshow(sceneImage);
% hold on;
% line(newBoxPolygon(:, 1), newBoxPolygon(:, 2), 'Color', 'y');
% line(newElephantPolygon(:, 1), newElephantPolygon(:, 2), 'Color', 'g');
% title('Detected Elephant and Box');
% 
