function filteredImage = preprocessSliceImage(img, GAMMAVAL)
% to be used with single images
% histogram stretching & Gamma correction
if (~exist('DOGAMMA', 'var'))
    GAMMAVAL = 0.9;
end

HIGH_GAMMA_VAL = 0.5;

histoStretchLimits = stretchlim(img, [0 0.9999]); % from zero to 99.9%
HSimg = imadjust(img,histoStretchLimits,[], 1); %no gamma adjustment in default

% for very strong expression values, adjust gamma and histogram a bit so we
% don't lose the background mask ...
%disp('Gamma adjusting ... ');
if ((max(HSimg(:)) - mean(HSimg(:))) > 0.98)

    HSimg = imadjust(img,[],[], HIGH_GAMMA_VAL);
    %normalizing brightness across slice
    HSimg = adapthisteq(HSimg, 'Distribution','rayleigh', 'NumTiles', [3 4]);
else
    HSimg = imadjust(img,[],[], GAMMAVAL);
end




% gaussian denoising


HSimg = imgaussfilt(HSimg, 6);


filteredImage = HSimg;
