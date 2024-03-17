function [slideExpressionData expressionMeasures expressionVolume expressionVolumeIMG] = quantifyExpressionInSlide(cziFileName, dataFolder, SLICEIDS, MAKEVOLPLOT)
% goes through all the slices contained (as positions/scenes) in the czi
% file; if SLICEIDS is not empty, process the positions indicates (in case
% one file contains more than 1 slide)
% SLIDEIDS is an array of indexes of slices to include, e.g. 1:12
%MAKEVOLPLOT = 0;
R = [];
if (~exist('SLICEIDS', 'var'))
    SLICEIDS = []; % this means we take all of them
end

if (~exist('MAKEVOLPLOT', 'var'))
    MAKEVOLPLOT = 0; %no plotting
end

MAKESLICEPLOT = MAKEVOLPLOT;


if (isunix)
    separator = '/';
else
    separator = '\';
end

%%check if we can find the file:
fileString =  [dataFolder separator cziFileName];
dirlist = dir (fileString);
if isempty(dirlist)

    warning(['File ' cziFileName ' not found on path ' dataFolder]);
else

    fileNames = dirlist.name;


    metaData = GetOMEData(fileString);
    disp(['Loading czi file ' cziFileName ' with ' num2str(metaData.SeriesCount) ' slices/series']);

    V = bfopen(fileString);
    V = V(:, 1); % drop extra info
    % drop unnecessary slices
    if ~isempty(SLICEIDS)
        if length(SLICEIDS) > metaData.SeriesCount
            SLICEIDS = 1:metaData.SeriesCount;
        end
        V = V(SLICEIDS);
    end

    %% process each slice
    nSlices = length(V);
    for slice = 1:nSlices
        sliceStack = cat(3, V{slice}{:, 1});
        disp (['Processing slice ' num2str(slice) ' ...']);
        expressionMeasures{slice} = quantifyExpressionInStack(sliceStack);
    end

    %% make summary plot of slide
    %     expMaskImg = zeros(size(expressionMeasures{1}.expMaskImg));
    %     expMaskImg = repmat(expMaskImg, 1, 1, nSlices);
    expressionVolume = 0;
    for slice = 1:nSlices
        relativeExpressionArea(slice) =  expressionMeasures{slice}.relativeExpressionArea;
        bilaterality(slice) =  expressionMeasures{slice}.bilaterality;
        localization(slice) = expressionMeasures{slice}.localization;
        expressionVolume = sum( [expressionVolume expressionMeasures{slice}.relativeExpressionArea], 'omitnan');
        expressionStrength(slice) = expressionMeasures{slice}.expressionStrength;
        mask = imresize(expressionMeasures{slice}.expMaskImg, 0.1);
        expMaskImg(:, :, slice) = mask;
    end
    slideExpressionData = [relativeExpressionArea' bilaterality' localization' expressionStrength'];
    expressionMeasures = {'Area' 'bilaterality' 'localization' 'strength'};
    % if no expression was found, everything marked zero
    if isempty(find(~isnan(slideExpressionData)))
        slideExpressionData(:, :) = 0;
    end

    % expand the expression mappings for a neat 3D vis
    [rows,cols,slices] = size(expMaskImg);
    [X,Y,Z] = meshgrid(1:cols, 1:rows, 1:slices);
    % just roughly by eye,20x expansion in z looks good
    [X2,Y2,Z2] = meshgrid(1:cols, 1:rows, 0.1:0.1:slices);
    expressionVolumeIMG = interp3(X, Y, Z, expMaskImg, X2, Y2, Z2, 'linear', 0);
    if MAKEVOLPLOT
        disp('Visualizing expression volumes ... ');
        h = volshow(expressionVolumeIMG);
        h.RenderingStyle = "GradientOpacity";
    end

    if MAKESLICEPLOT
        disp('Visualizing slice data  ... ');
        DOGAMMA = 0;


        first_columns = cellfun(@(x) x(:,1), V, 'UniformOutput', false);
        first_columns_3D = cat(1, first_columns{:});
        first_columns_3D_matrix = cat(3, first_columns_3D{:});

        [rows,cols,slices] = size(first_columns_3D_matrix);
        sliceStackSCALED = im2double(imresize3(first_columns_3D_matrix,[rows/2 cols/2 slices]));
        sliceStackFILT = preprocessImageStack(sliceStackSCALED, DOGAMMA);


%         [rows,cols,slices] = size(sliceStackFILT);
%         [X,Y,Z] = meshgrid(1:cols, 1:rows, 1:slices);
%         % just roughly by eye,20x expansion in z looks good
%         [X2,Y2,Z2] = meshgrid(1:cols, 1:rows, 0.1:0.2:slices);
%         sliceVolStack = interp3(X, Y, Z, double(sliceStackFILT), X2, Y2, Z2, 'linear', 0);

        volshow(sliceStackFILT, 'RenderingStyle', 'SlicePlanes');
    end

end
end

