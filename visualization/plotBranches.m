function [R] = plotBranches(skeletonImageStack,imageInfo, curliness)
% Define colors based on curvedness values

branchStats = getBranchesFromSkeletonStack(skeletonImageStack);


nBranches = length(curliness);
curvednessColors = jet(nBranches); % jet colormap
curvednessValues = curliness;

[xyResolution, zResolution] = getPixelResolution(imageInfo);

% Initialize figure
figure;

% Loop over all branches
for i = 1:nBranches

        % Get branch voxel list
        branchVoxels = branchStats.VoxelList{i};
        
        % Convert branch voxel list to micrometers
        branchVoxelsMicrons = branchVoxels ./ [xyResolution, xyResolution, zResolution];

        % Plot branch as line segments with color based on curvedness
        line(branchVoxelsMicrons(:,1), branchVoxelsMicrons(:,2), branchVoxelsMicrons(:,3), 'Color', curvednessColors(i,:), 'LineWidth', 0.5);
        hold on;
end


% Set axis labels
xlabel('X (\mum)');
ylabel('Y (\mum)');
zlabel('Z (\mum)');

% Set axis limits
daspect([1 1 1]) % Set equal aspect ratio
% Add colorbar legend
colormap(jet);
c = colorbar;
c.Label.String = 'Curledness';

R = 1;
