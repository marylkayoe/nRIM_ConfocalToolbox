function [skeletonImageStack] = skeletonizeImageStack(imageStack,imageInfo, varargin)
% skeletonStack - skeletonize a stack of images
% preprocess using Tubeness filtering based on pixel resolution information 
% next, binarize the image and skeletonize it

% INPUTS

% imageStack - 3D matrix of images
% imageInfo - image information structure

% OUTPUTS
% skeletonStack - 3D matrix of skeletonized images (in logical format)
% branchPoints - 3D matrix of branch points (in logical format)

expectedDendriteThickness =2;
%% 
if ~isempty(varargin)
    expectedDendriteThickness = varargin{1};
end

[xyResolution zResolution]= getPixelResolution(imageInfo);
%% first: tubeness
expectedDendriteThicknessPIXELS = ceil(expectedDendriteThickness * xyResolution);

tubenessStack = fibermetric(imageStack,expectedDendriteThicknessPIXELS);

% remove small dots from the tubeness image that are circular
% and have a radius less than 10 pixels
% this is to remove noise from the tubeness image
% and to make the skeletonization process faster
% the number 10 is arbitrary and can be changed
% depending on the expected thickness of the dendrites
% in the image
%tubenessStack = bwareaopen(tubenessStack, 300);
% 
% [x, y, nSlices] = size(imageStack);
% tubenessStack = double(bwmorph3(tubenessStack, 'clean'));
thresholdSensitivity = 0.5;
% %binarize adaptively
T = adaptthresh(tubenessStack, thresholdSensitivity);  % Otsu's method
imageStackBin = imbinarize(tubenessStack,T);
%skeletonize
skeletonImageStack = bwskel(imageStackBin, 'MinBranchLength',50);

% Smooth the skeleton using morphological closing
% se = strel('sphere', 2);
% skeletonImageStack = imclose(skeletonImageStack, se);


