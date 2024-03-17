function [meshVols meshAreas] = getSpineVolumes(dataFolder)
VOXELSIZE = 6; %nm
MESHRES = 100; % some value of mesh precision, should not be smaller than this
searchString = '*.stl'; % other string matching can be used eg.only use files with "spine" in filename
MAKEFIG = 1;

meshVols = [];
[stlFileNames] = getStlFileNames(dataFolder, searchString);
if isempty(stlFileNames)
    warning ('no stl files found');
else
     nObjects = length(stlFileNames);
    if MAKEFIG
        figure; hold on;
        nCOLS = ceil(nObjects / 3)+1;
        nROWS = 3;
    end
    

    for i = 1:nObjects
        disp('Making geometries');
        [meshVols(i) meshAreas(i)] = getVolumeAreaFromSTL(stlFileNames{i}, VOXELSIZE, MESHRES);
        if MAKEFIG
            pd = createpde;
            importGeometry(pd,stlFileNames{i});
            msh = generateMesh(pd,'Hmax',MESHRES, 'Hmin',20);
            
            subplot(nROWS, nCOLS, i);
            pdemesh(msh, 'FaceAlpha',0.5)
        end
        
    end
end
end

