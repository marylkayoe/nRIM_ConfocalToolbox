function distances = getBranchDistancesFromSkeletonStack(skeletonImageStack, imageInfo)

    branchStats = getBranchesFromSkeletonStack(skeletonImageStack);
    nBranches = height(branchStats);

    branchPoints = bwmorph3(skeletonImageStack, 'branchpoints');
    endPoints = bwmorph3(skeletonImageStack, 'endpoints');
    
    [xyResolution, zResolution] = getPixelResolution(imageInfo);
    endPoints = bwmorph3(skeletonImageStack, 'endpoints');


    for i = 1:nBranches

        % Get voxel coordinates of branch endpoints
        [endY, endX, endZ] = ind2sub(size(endPoints), branchStats.VoxelIdxList{i});
        branchVoxels = [endX, endY, endZ]./[xyResolution, xyResolution, zResolution];

        % Calculate Euclidean distance between endpoints
        branchVector = branchVoxels(end, :) - branchVoxels(1, :);
        euclideanDistance(i) = norm(branchVector);
    end

    distances = euclideanDistance';

end
