function [imageStack, imageInfo] = importZeissStack(dataPath, fileName, varargin)
    %% IMPORTZEISSSTACK imports a Zeiss LSM image stack based on bioformats toolboxes.
    %% Input: path to the image file, filename; optional: channel to import
    %% Output: image stack as a 3D matrix; if channel is specified, only the specified channel is imported.
    %%         imageInfo: a structure containing the image information from file metadata

    %% check input

    if nargin < 2
        error('Please specify the path and filename.');
    end

    if nargin > 2
        channel = varargin{1};
    else
        channel = 0;
    end

    % create full file path from dataPath and fileName
    fileString = fullfile(dataPath, fileName);

    %% import image stack using bfopen
    [data] = bfopen(fileString);
    OMEdata = GetOMEData(fileString);
    disp(['Loading czi file ' fileName ' with ' num2str(OMEdata.SeriesCount) ' slices/series']);

    imageStack = data{1}(:, 1); % keep only the image data
    imageStack = cat(3, imageStack{:}); % convert to 3D matrix

    imageInfo = OMEdata;
    disp(['Read file', fileString]);
