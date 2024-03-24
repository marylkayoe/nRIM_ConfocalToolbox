function [scenes, imageInfo] = importZeissStack(dataPath, fileName, varargin)
    %% IMPORTZEISSSTACK imports a Zeiss LSM image stack based on bioformats toolboxes.
    %%
    %% Input: path to the image file, filename; optional: channel to import
    %% Output: scenes: image stacks
    %%         imageInfo: a structure containing the image information from file metadata
    % Note: currently metadata is given for first image with the assumption
    % that everything is same in all scenes
    %% check input

    scenes = [];
    imageInfo = [];

    if nargin < 2
    warning('Please specify the path and filename.');
    return;
    end

    if nargin == 3
        channel = varargin{1};
    else
        channel = 1; % default channel is 1
    end

    % define output variables as empty arrays


    % create full file path from dataPath and fileName
    filePath = fullfile(dataPath, fileName);

    if ~isfile(filePath)
        warning(['File ' filePath ' not found, aborting.']);
        return;
    end

    %% import image stack using bfopen
    [zeissData] = bfopen(filePath);

    % check if the data is empty
    if isempty(zeissData)
        warning(['No data found in file ' fileString ', aborting import.']);
        return;
    end

    % read metadata to find out how many scenes / positions there are
    imageInfo = GetOMEData(filePath);
    [imageInfo.LaserWL imageInfo.LaserPower, imageInfo.zoom, imageInfo.acqDate] = getZeissMetadata(zeissData{1, 2}); % the Zeiss-specific data are here
    nSCENES = imageInfo.SeriesCount;

    if isempty(nSCENES)
        nSCENES = 1;
    end

    nChannels = imageInfo.SizeC;
    nImagesInStack = imageInfo.SizeZ;

    disp(['Loaded czi file ' fileName ' with ' num2str(nSCENES) ' slices/series, ' num2str(nChannels) ' channels']);

    % if there are more than one channel
    if nChannels > 1
        % check if the channel is valid
        if channel < 0 || channel > nChannels
            warning(['Invalid channel number ' num2str(channel) ', defaulting to first channel']);
            channel = 1;
        end

        % IMPORTANT: In zeiss file import, the images for channels are shown one
        % after another, interleaved!
        % so channel 0 is in rows 1:2:2*nImagesInStack, channel 1 is in rows 2:2:2*nImagesInStack
        % so to get the images for a channel, we need to calculate indexes for each channel
        % general calculation for images in channel c:

        % nImagesInStack = number of images in a stack
        % nChannels = number of channels
        % channel = channel number to import
        % if there are 2 channels:
        % channel indexes for channel 1 are 1, 3, 5, ... nChannels*nImagesInStack - 2 + 1 (next to last)
        % channel indexes for channel 2 are 2, 4, 6, ... nChannels*nImagesInStack  - 2 + 2 (last)

        startRow = channel;
        endRow = nChannels * nImagesInStack - nChannels + channel;
        channelRows = [startRow:nChannels:endRow];

        imageInfo.Dyes = imageInfo.Dyes{channel};

    end

    % reformat into cell array for easier handling later

    scenes = cell(1, nSCENES);

    for i = 1:nSCENES
        scenes{i} = cat(3, zeissData{i}{channelRows, 1});
        %  scenes{i} = cat(3, zeissData{i}{:, 1});
    end

    % select the images for the channel
    % convert to double
    %scenes = cellfun(@double, scenes, 'UniformOutput', false);
