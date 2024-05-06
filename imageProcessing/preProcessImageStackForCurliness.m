function processedImageStack = preProcessImageStackForCurliness(imageStack, imageInfo, REMOVESOMAS)
% 
% make sure we have even number of slices
[imgSizeX imgSizeY nSlices]  = size(imageStack);
if (mod(nSlices, 2)) %it's odd
    imageStack(:, :, end) = [];
end
% Preprocesses a stack of images
%processedImageStack = adjustHistogram(imageStack);
processedImageStack = imageStack;
[xyResolution, zResolution] = getPixelResolution(imageInfo);
%processedImageStack = KuwaharaFourier(processedImageStack, 1);
noSomaRemoved = processedImageStack;
if REMOVESOMAS
    [filteredImageStack] = removeSomataFromStack(processedImageStack, xyResolution);
    processedImageStack = filteredImageStack;
end

% figure; 
% subplot(1,2, 1); hold on;title ('Histogram adjusted');
% imshow(std(double(noSomaRemoved), [], 3), []);
% 
% subplot(1,2, 2); hold on;title ('with soma filtering');
% imshow(std(double(filteredImageStack), [], 3), []);
% % 

%imshowpair(std(double(imageStack), [], 3),std(double(processedImageStack), [], 3), 'montage');


