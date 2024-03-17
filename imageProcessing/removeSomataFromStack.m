function [imageStackFiltered, somaMask] = removeSomataFromStack(imageStack, xyResolution)


DOWNSAMPLEFACTOR = 0.5;
UPSAMPLEFACTOR = 1 / DOWNSAMPLEFACTOR;
imageStack = double(imageStack);

resizedStack = imresize3(imageStack, DOWNSAMPLEFACTOR);
[imgSizeX imgSizeY nSlices]  = size(resizedStack);
somaMask = false(size(resizedStack));
kuwaharaFiltered = KuwaharaFourier(resizedStack, 7);

% Estimate background noise level
SOMASIZEUM = 300 / UPSAMPLEFACTOR;
% Compute the threshold area in pixels
thresholdArea = round(SOMASIZEUM * (xyResolution^2));


%%
% Compute a threshold using the middle slice and Otsu's method
 NLEVELS = findNLevelsForImage(kuwaharaFiltered(:, :, ceil(nSlices/2)), 0.85);
 thresholds = multithresh(kuwaharaFiltered(:, :, ceil(nSlices/2)), NLEVELS);
 somaMask = kuwaharaFiltered >thresholds(end-1);
 %NLEVELS = 4;
% for i = 1:nSlices
%     slice = kuwaharaFiltered(:, :, i);
%     thresholds = multithresh(slice, NLEVELS);
%     somaMask(:, :, i) = slice > thresholds(end-1);
% end
% Remove small regions from the soma mask
somaMask = bwareaopen(somaMask, thresholdArea, 26);

%
% Dilate the soma mask to connect nearby regions
se = strel('sphere', ceil(5*DOWNSAMPLEFACTOR));
somaMask = imdilate(somaMask, se);

% Fill in any gaps in the soma mask
somaMask = imfill(somaMask, 'holes');


% Initialize filtered image stack as logical array
imageStackFiltered = imageStack;
% Set pixels corresponding to somata to 0 in filtered image stack
somaMask = imresize3(somaMask, UPSAMPLEFACTOR);
BGlevelMean = mean (imageStack(imageStack<thresholds(1)));

imageStackFiltered(somaMask) = BGlevelMean;

% Convert filtered image stack back to double
imageStackFiltered = double(imageStackFiltered);
%imageStackFiltered = adjustHistogram(imageStackFiltered);

% %Visualize original and filtered image stacks
% imshowpair(max(is, [], 3), std(imageStackFiltered, [], 3), 'montage');
% 
% imshow(max(imageStackFiltered, [], 3),'DisplayRange', [0, max(imageStackFiltered(:))]);
end
