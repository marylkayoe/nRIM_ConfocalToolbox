function avgSlice = makeAverageSliceFromStack(imageStack)

if isempty(imageStack)
    warning('Empty image stack!');
    avgSlice = [];
else
    avgSlice = mean(imageStack, 3);
end
