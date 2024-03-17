function [branchLengths, cleanSkeletonImageStack] = getBranchLengthsFromSkeletonStack(skeletonImageStack, imageInfo)
%GETBRANCHLENGTHSFROMSKELETONSTACK Returns the branch lengths of a skeleton

[branchStats] = getBranchesFromSkeletonStack(skeletonImageStack);
nBranches = size(branchStats, 1);
branchLengths = zeros(nBranches, 1);

[xyResolution, zResolution] = getPixelResolution(imageInfo);

% Loop over all branches
for i = 1:nBranches
    % Get branch voxel list
    branchVoxels = branchStats.VoxelList{i};
    branchVoxelCoords = branchVoxels ./ [xyResolution, xyResolution, zResolution];

    % Calculate branch length as sum of distances between consecutive voxels
    thisBranchLength = 0;
    for j = 1:size(branchVoxelCoords, 1)-1
        voxel1 = branchVoxelCoords(j,:);
        voxel2 = branchVoxelCoords(j+1,:);
        subVector = voxel2-voxel1;
        voxelDistance = norm(subVector);
        thisBranchLength = thisBranchLength + voxelDistance;
    end
    branchLengths(i) = thisBranchLength;
end
branchLengths(branchLengths>1000) = 100;