function [imageStackFiltered] = removeSomataFromStack(imageStack, xyResolution)

NLEVELS = findNLevelsForImage(imageStack, 0.95);
DOWNSAMPLEFACTOR = 0.5;
UPSAMPLEFACTOR = 1 / DOWNSAMPLEFACTOR;
imageStack = double(imageStack);
[imgSizeX imgSizeY nSlices]  = size(imageStack);
thresholds = multithresh(imageStack(:, :, ceil(nSlices/2)), NLEVELS);
quant_A = imquantize(imageStack,thresholds);

BGmask = quant_A<=NLEVELS/2;
%FGmask = quant_A >4;
imageStackFiltered = imageStack;
imageStackFiltered (BGmask)= 0;

% figure;
% imshowpair(stdProjectImage(imageStack), stdProjectImage(imageStackFiltered), "montage");

end
