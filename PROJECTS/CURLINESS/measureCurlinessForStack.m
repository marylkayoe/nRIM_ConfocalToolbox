function [meanCurliness, stdCurliness, semCurliness, curlyIndexes] = measureCurlinessForStack(imageStack,imageInfo)
%MEASURECURLINESSFORSTACK Measure the curliness of a stack of images.

meanCurliness = 0;
stdCurliness = 0;
REMOVESOMATA = true; % if there are somata in the image stack, they should be removed
%preprocess image
processedImageStack = preProcessImageStackForCurliness(imageStack, imageInfo, REMOVESOMATA);

%skeletonize image
skeletonStack = skeletonizeImageStack(processedImageStack,imageInfo);

figure; imshowpair(stdProjectImage(imageStack), stdProjectImage(skeletonStack));
%skeleton cleaning
[cleanSkeleton, branchStats] = cleanSkeletonStack(skeletonStack);
% get branch lenghts (and prune those too longh or short)
[branchLengths, branchStats] = getBranchLenghtsFromStats(branchStats, imageInfo);
nBranches = length(branchLengths);

[branchDistances] = getBranchDistances(branchStats, imageInfo);

figure; 
imshowpair(std(double(imageStack), [], 3), std(double(cleanSkeleton), [], 3), 'falsecolor');

title([cleanUnderscores(imageInfo.Filename), ' STD proj of image and cleaned-up skeleton']);
medianBranchLength = median (branchLengths, 'omitnan');

straightness = branchDistances ./ branchLengths;

curliness = 1 - straightness;
curlyIndexes = curliness ./ medianBranchLength;
curlyIndexes = curliness ;


meanStraightness = mean (straightness, 'omitnan');
meanCurliness = mean(curlyIndexes, 'omitnan');
stdCurliness = std(curlyIndexes, [],1, 'omitnan');
semCurliness = stdCurliness / sqrt(nBranches);

if 1
    figure;
    t = tiledlayout(2, 2);
    t.Padding = 'compact';
    t.TileSpacing = 'compact';
    title(t, cleanUnderscores(imageInfo.Filename));

    ax = nexttile([1 2]);
    imshowpair(std(double(imageStack), [], 3), std(double(cleanSkeleton), [], 3), 'montage');
    title (ax, 'STD proj of image and cleaned skeleton');

    ax = nexttile;
    histogram(branchLengths, 100, 'Normalization','countdensity'); xlim ([0 200]); title (ax, 'branch lenghts');

    ax = nexttile;
    histogram(branchDistances, 100, 'Normalization','countdensity'); xlim ([0 50]);  title (ax, 'branch distances');
    volshow(double(cleanSkeleton), "RenderingStyle","Isosurface");
end
