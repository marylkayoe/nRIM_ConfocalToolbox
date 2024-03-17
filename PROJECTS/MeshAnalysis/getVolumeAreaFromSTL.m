function [meshVol meshArea] = getVolumeAreaFromSTL(stlFileName, voxelSize, res)
% calculate volume from mesh of the stl
% stl file needs to be checked before calling

if (~exist('voxelSize', 'var'))
    voxelSize = '6'; % dimension of voxels in nm
end

if (~exist('res', 'var'))
    res = 100; % mesh resolution
end

disp(stlFileName);

pdem = createpde;
geom = importGeometry(pdem, stlFileName);
msh = generateMesh(pdem, 'Hmax',res);
v = msh.volume();
meshVol = v*voxelSize;
meshVol = meshVol / 1e9; % convert to cubic um


[F, V] = geom.allDisplayFaces();
a = V(F(:, 2), :) - V(F(:, 1), :);
b = V(F(:, 3), :) - V(F(:, 1), :);
c = cross(a, b, 2);
meshArea = 1/2 * sum(sqrt(sum(c.^2, 2)));
meshArea = meshArea *voxelSize;
meshArea = meshArea / 1e-6;
