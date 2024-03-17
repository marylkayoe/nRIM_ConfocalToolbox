function distances = getBranchDistances(branchStats, imageInfo)

nBranches = height(branchStats);
[xyResolution, zResolution] = getPixelResolution(imageInfo);
distances = zeros(nBranches, 1);

for i = 1:nBranches
    % Get voxel coordinates of branch endpoints
    voxelList = branchStats.VoxelList{i};
    branchVoxels = voxelList./[xyResolution, xyResolution, zResolution];

    % Calculate Euclidean distance between endpoints
    branchVector = branchVoxels(end, :) - branchVoxels(1, :);
    euclideanDistance = norm(branchVector);
    distances(i) = euclideanDistance;
end

end
