function folderTHimage = makeFolderThumbnails(dataFolder, varargin)
% generates a collage of thumbnails for all CZI files in the specified folder
% uses makeThumbnailFromFile function to generate thumbnails

% input arguments:
% dataFolder - path to the folder containing CZI files

% optional arguments:
% 'method' - method to be used for creating the thumbnail image;
% default is std projection, other options: 'max', 'min', 'mean', 'median'

% frameIndex - index of the frame to be used for creating the thumbnail image;
% default is 'all', other options: 'first', 'last', 'middle', 'random'

% newHeight - height of the thumbnail image; default is 512
% aspectRatio - aspect ratio of the thumbnail image; options: 'original', 'square'; default is 'square'
% imageDescriptor - descriptor for the image; default is empty. Strings longer than 30 characters will be truncated

% channel - channel to be used for creating the thumbnail image; default is 1. Note if the image has only one channel, this argument is ignored

    % Parse optional arguments (like output size or specific file extensions)
    p = inputParser;
    addRequired(p, 'dataFolder', @ischar);
    addParameter(p, 'method', 'std', @(x) ischar(x) && ismember(x, {'std', 'max', 'min', 'mean', 'sum'}));
    addParameter(p, 'frameIndex', 'all', @(x) ischar(x) && ismember(x, {'all', 'first', 'last', 'middle', 'random'}));
    addParameter(p, 'newHeight', 512, @(x) isnumeric(x) && x > 0);
    addParameter(p, 'aspectRatio', 'square', @(x) ischar(x) && ismember(x, {'original', 'square'}));
    addParameter(p, 'imageDescriptor', '', @(x) ischar(x));
    addParameter(p, 'channel', 1, @(x) isnumeric(x) && x > 0);

    parse(p, dataFolder, varargin{:});

folderTHimage = [];

    % check if the dataFolder exists
    if ~isfolder(dataFolder)
        disp('The specified folder can not be found, aborting.');
        return;
    end

    % Find CZI files in the specified folder
    cziFiles = dir(fullfile(dataFolder, '*.czi'));
    numFiles = numel(cziFiles);

    if numFiles == 0
        disp('No CZI files found in the specified folder.');
        return;
    end

    % Preallocate array for thumbnail images
    THimages = cell(numFiles, 1);
    figure('Visible', 'off'); % Create a figure for montage creation, but do not display it

    for i = 1:numFiles
        % Construct the full file path
        filePath = fullfile(cziFiles(i).folder, cziFiles(i).name);

        SLIDEID = getSlideIDfromFilename(cziFiles(i).name);
        imageDescriptor = cziFiles(i).name;
        
        % Generate thumbnail image for the current file
        THimage = makeThumbnailFromFile(dataFolder, cziFiles(i).name, 'newHeight', p.Results.newHeight, 'method', p.Results.method, 'frameIndex', p.Results.frameIndex, 'aspectRatio', p.Results.aspectRatio, 'imageDescriptor',imageDescriptor, 'channel', p.Results.channel);
        
        % Store the thumbnail image
        THimages{i} = THimage;
    end

    % Create a montage of all thumbnails
    THmontage = makeThumbnailMontage(THimages);
    %montage(THimages, 'Size', [ceil(sqrt(numFiles)), ceil(sqrt(numFiles))], 'BorderSize', [10 10], 'BackgroundColor', 'black');

    % Save the montage to a PNG file
    outputFileName = fullfile(dataFolder, 'thumbnails_montage.png');
    imwrite(THmontage, outputFileName, 'png');
    disp(['Thumbnail montage saved as: ', outputFileName]);

 
end
