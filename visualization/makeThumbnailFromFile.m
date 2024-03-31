function THimage = makeThumbnailFromFile (dataFolder, fileName, varargin)
% makeThumbnailFromFile: Create a thumbnail image from a file
% this is a wrapper for makeThumbnailFromImageStack (that makes the thumbnail from an image stack)

% uses importZeissStack for reading Zeiss image files,
% and imread for other image files (tiff etc)

% Input arguments:
% filePath: path to the image file (including the file name)
% varargin: optional arguments to be passed to makeThumbnailFromImageStack

% optional arguments:
% 'method' - method to be used for creating the thumbnail image;
% default is std projection, other options: 'max', 'min', 'mean', 'median'

% frameIndex - index of the frame to be used for creating the thumbnail image;
% default is 'all', other options: 'first', 'last', 'middle', 'random'

% newHeight - height of the thumbnail image; default is 512
% aspectRatio - aspect ratio of the thumbnail image; options: 'original', 'square'; default is 'square'
% imageDescriptor - descriptor for the image; default is empty. Strings longer than 30 characters will be truncated

% channel - channel to be used for creating the thumbnail image; default is 1. Note if the image has only one channel, this argument is ignored

% Output arguments:
% THimage: thumbnail image (RGB)

% parse input arguments
p = inputParser;

% add required parameters
addRequired(p, 'dataFolder', @ischar);
addRequired(p, 'fileName', @ischar);
%  optional parameters
addParameter(p, 'method', 'std', @ischar);
addParameter(p, 'frameIndex', 'all', @ischar);
addParameter(p, 'newHeight', 512, @isnumeric);
addParameter(p, 'aspectRatio', 'square', @ischar);
addParameter(p, 'imageDescriptor', '', @ischar);
addParameter(p, 'channel', 1, @isnumeric);

% parse the input
parse(p, dataFolder, fileName, varargin{:});
% initialize empty thumbnail
THimage = [];

filePath = fullfile(dataFolder, fileName);
% check if filepath is correctly formed
if ~isfile(filePath)
    warning(['File ' p.Results.filePath ' not found']);
    return;
end

% check the file type
% currently working with ZEISS czi files and tiff stacks
[~, ~, ext] = fileparts(p.Results.fileName);
if strcmp(ext, '.czi')
    % read the image stack
    [imageStack, imageInfo] = importZeissStack(dataFolder, fileName, p.Results.channel);
    if iscell(imageInfo.Dyes)
        channelInfo = imageInfo.Dyes{1};
    else

        channelInfo = imageInfo.Dyes;
    end

    nSERIES = imageInfo.SeriesCount;

else
    % read the normal image stack
    imageStack = importTiffStack(filePath);
    imageStack = {imageStack}; % pack it in cell so that it looks the same as zeiss files
    channelInfo = [];
    imageInfo = [];

    nSERIES = 1;

end

% generate image descriptor - from filename.
% characters up to second separator (-) is presumed SLIDEID
SLIDEID = getSlideIDfromFilename(p.Results.fileName);

if isempty(p.Results.imageDescriptor)
    imageDescriptorRoot = SLIDEID;
else
    imageDescriptorRoot = [p.Results.imageDescriptor '-' SLIDEID];
end

%imageDescriptor = [imageDescriptor '-' channelInfo];

% make the thumbnail
for series = 1:nSERIES
    imageDescriptor = [imageDescriptorRoot '-' num2str(series) ' - ' channelInfo];
    THimages{series} = makeThumbnailFromImageStack(imageStack{series}, 'method', p.Results.method, 'frameIndex', p.Results.frameIndex, 'newHeight', p.Results.newHeight, 'aspectRatio', p.Results.aspectRatio, 'imageDescriptor', imageDescriptor);
end

if nSERIES ==1
    THimage = THimages{1};
else
    THimage = makeThumbnailMontage(THimages);
end

end


