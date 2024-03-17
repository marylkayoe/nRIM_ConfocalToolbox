function preprocessedStack = preprocessImageStack(imgStack, GAMMAVAL)
% preprocess all images in a stack and return as a new stack
if (~exist('DOGAMMA', 'var'))
    GAMMAVAL = 0.8;
end

if isempty(imgStack)
    warning('Empty image stack!');
    preprocessedStack = [];
else
%imgStack = im2double(imgStack);
    [ysize xsize zsize] = size(imgStack);

    for z = 1:zsize
        zSection{z} = imgStack(:, :, z);
        ppZsection{z} = preprocessSliceImage(zSection{z}, GAMMAVAL);
    end

    preprocessedStack = cat(3, ppZsection{:});

end