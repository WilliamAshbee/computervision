%unzip('MerchData.zip');
%imds =  imageDatastore('MerchData','IncludeSubfolders',true,'LabelSource','foldernames');
imds =  imageDatastore('cutlery','IncludeSubfolders',true,'LabelSource','foldernames');
tbl = countEachLabel(imds)
figure
montage(imds.Files(1:end))
title('montage')
[trainingSet, validationSet] = splitEachLabel(imds, 0.9, 'randomize');

bag = bagOfFeatures(trainingSet);
img = readimage(imds, 1);
featureVector = encode(bag, img);

% Plot the histogram of visual word occurrences
figure
bar(featureVector)
title('Visual word occurrences')
xlabel('Visual word index')
ylabel('Frequency of occurrence')

categoryClassifier = trainImageCategoryClassifier(trainingSet, bag);

confMatrix = evaluate(categoryClassifier, trainingSet);

confMatrix = evaluate(categoryClassifier, validationSet);

% Compute average accuracy
mean(diag(confMatrix))

