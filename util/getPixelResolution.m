function [xyResolution, zResolution] = getPixelResolution(imageInfo)
% how many pixels per um
    xyResolution = 1 / imageInfo.ScaleX;
    zResolution = 1 / imageInfo.ScaleZ;
