function maskStack = getBGmasksForStack(imgStack)
% preprocess all images in a stack and return as a new stack

if isempty(imgStack)
    warning('Empty image stack!');
    preprocessedStack = [];
else


    [ysize xsize zsize] = size(imgStack);

    for z = 1:zsize
        zSection{z} = imgStack(:, :, z);
        bgMask{z} = getBGmaskFromSlice(zSection{z});

    end
    maskStack = cat(3, bgMask{:});
end