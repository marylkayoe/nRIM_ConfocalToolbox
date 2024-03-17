function [skeletonImageStackFiltered, branchStats] = cleanSkeletonStack(skeletonImageStack)

% Get the statistics of the branch lengths
branchStats = regionprops3(skeletonImageStack, "VoxelIdxList", "VoxelList", 'BoundingBox');
branchLengthsVoxels = cellfun(@length, branchStats.VoxelList);
% branchStats(branchLengthsVoxels > 1000, :) = [];
% branchLengthsVoxels(branchLengthsVoxels > 1000) = [];

nBranches = height(branchStats);

branchLengths3D = zeros(nBranches, 3);

for i = 1:nBranches
    boundingBox = table2array(branchStats(i, 'BoundingBox'));
    branchLengths3D(i, :) = [boundingBox(4), boundingBox(5), boundingBox(6)];
end

% Calculate ratio of length in z dimension to length in x and y dimensions
zToXYLengthRatio = branchLengths3D(:, 3) ./ mean(branchLengths3D(:, 1:2), 2);
xyTozLengthRatio = mean(branchLengths3D(:, 1:2), 2)./ branchLengths3D(:, 3) ;
% Set threshold for z to xy length ratio
XYtozLengthRatioThreshold = 1.4;

% Filter branches based on z to xy length ratio
filteredBranchIndices = find(xyTozLengthRatio > XYtozLengthRatioThreshold);
filteredBranchStats = branchStats(filteredBranchIndices, :);
nBranchesFiltered = height(filteredBranchStats);
% Initialize a new binary skeleton image stack
skeletonImageStackFiltered = false(size(skeletonImageStack));
% Loop over the filtered branches and set the corresponding voxels to 1 in the new stack
for i = 1:nBranchesFiltered
    % Get the voxel indices for the i-th filtered branch
    voxelIndices = table2array(filteredBranchStats(i, 'VoxelIdxList'));
    voxelIndices = voxelIndices{1};
    % Set the corresponding voxels to 1 in the new stack
    skeletonImageStackFiltered(voxelIndices) = 1;


end


end

