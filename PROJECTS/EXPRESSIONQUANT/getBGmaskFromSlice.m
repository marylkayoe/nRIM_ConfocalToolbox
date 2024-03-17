function bgMask = getBGmaskFromSlice(img)
% returns mask where background = 0, slice = 1

% It is important to do some preprocessing before this - e.g. gaussian filter

% The n levels for thresholding is decided based on how many levels are
% needed to reach 90% coverage
THLEVEL = 0.95;
NLEVELS = findNLevelsForImage(img, THLEVEL);

thresh = multithresh(img, NLEVELS);
bgMask = imquantize(img,thresh);
bgMask(bgMask==1) = 0;

bgMask (bgMask>0) = 1;

