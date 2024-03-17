function adjustedImage = adjustHistogram(imageStack)
%ADJUSTHISTOGRAM Adjust the histogram of an image.
%   ADJUSTEDIMAGE = ADJUSTHISTOGRAM(imageStack) adjusts the histogram of the
%   input image, IMAGE, and returns the adjusted image, ADJUSTEDIMAGE. The
%   function adjusts the histogram of imageStack so that the minimum and maximum
%   values of the output image are 0 and 255, with 8-bit images, or 0 and
%   65535, with 16-bit images. 


%imageStack = double(imageStack);

% Compute the stretchlim values based on the whole stack
lowHigh = stretchlim(imageStack, [0.1, 0.99])';

% Loop over all images in the stack and adjust the contrast using imadjust
for i = 1:size(imageStack, 3)
    % Adjust contrast of the i-th image in the stack
    adjustedImage(:,:,i) = imadjust(imageStack(:,:,i), lowHigh(i, :));
end

%imshowpair((max(imageStack,[],3)), (max(adjustedImage,[],3)), 'montage');
