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

expectedDendriteThickness =1;
if ~isempty(varargin)
    expectedDendriteThickness = varargin{1};
end

[xyResolution zResolution]= getPixelResolution(imageInfo);
%% first: tubeness
expectedDendriteThicknessPIXELS = ceil(expectedDendriteThickness * xyResolution)*2;

tubenessStack = fibermetric(imageStack,expectedDendriteThicknessPIXELS);
[x, y, nSlices] = size(imageStack);
tubenessStack = double(bwmorph3(tubenessStack, 'clean'));
thresholdSensitivity = 0.5;
%binarize adaptively
T = adaptthresh(tubenessStack, thresholdSensitivity);  % Otsu's method
imageStackBin = imbinarize(tubenessStack,T);
%skeletonize
skeletonImageStack = bwskel(imageStackBin, 'MinBranchLength',50);

% Smooth the skeleton using morphological closing
se = strel('sphere', 2);
skeletonImageStack = imclose(skeletonImageStack, se);


