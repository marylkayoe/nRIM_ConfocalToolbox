function [meshVol] = getVolumeFromSTL(stlFileName, voxelSize, res)
% calculate volume from mesh of the stl
% stl file needs to be checked before calling

if (~exist('voxelSize', 'var'))
    voxelSize = '6'; % dimension of voxels in nm
end

if (~exist('res', 'var'))
    res = 100; % mesh resolution
end


pdem = createpde;
geom = importGeometry(pdem, stlFileName);
msh = generateMesh(pdem, 'Hmax',res);
v = msh.volume();
meshVol = v*voxelSize;
meshVol = meshVol / 1e9; % convert to cubic um

