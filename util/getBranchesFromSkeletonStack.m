function [branchStats] = getBranchesFromSkeletonStack(skeletonImageStack)

% Get the statistics of the branch lengths
branchStats = regionprops3(skeletonImageStack, "VoxelIdxList", "VoxelList", 'BoundingBox');
