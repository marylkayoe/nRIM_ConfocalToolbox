function [segmented_image expressionFOUND expressionStrength expressionStrengthNorm] = getExpressionSegments(img, bgMask, segTH)
% return the image segmented so that the expressing region is in the LAST
% label

% make sure the background is properly masked (made 0)

if ~exist('segTH', 'var')
    segTH = 0.85;
end


disp('Segmenting af and expression...');

NLEVELS = findNLevelsForImage(img, segTH); % add one because the BG is removed

%selecting pixel values that are "AF", expression: (nans are automatically ignored)
warning('off');
thresh = multithresh(img, NLEVELS);
warning('on');

%% note: need to add checking for a minimum level of expression, e.g. 2SD over noise

segmented_image = imquantize(img, thresh);

expressionRegionMask = zeros(size(segmented_image));
expressionRegionMask (segmented_image == max(segmented_image, [], 'all')) = 1;
if NLEVELS > 4 % to take in more levels in imageß
    expressionRegionMask (segmented_image == max(segmented_image, [], 'all')-1) = 1;
    disp('merging two top segments');
end
segmented_image = segmented_image -1; % so that BG is omitted
% the intensity threshold denoting last label is the "threshold" for lowest
% intensity considered as "expressing"

imageNoiseCeiling = getImageNoise(img, bgMask);
expressionRegionFloor = getExpressionFloor(img, expressionRegionMask);
%expressionSNR = expTH / imageNoiseLevel;
expressionFOUND = expressionRegionFloor > imageNoiseCeiling*1.2;
%disp(['Expression SNR at segmentation TH=' num2str(segTH) ':  ' num2str(expressionSNR, 3) '.']);
expressionStrength = mean(img(expressionRegionMask == 1), 'all', 'omitnan');
expressionStrengthNorm = expressionStrength - imageNoiseCeiling;
