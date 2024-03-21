function R = makeSlideOverviewFromFile(filePath, varargin)
% makeSlideOverviewFromFile - create a slide overview from a file
% the image is saved as .png in the same folder as the file
% input arguments:
%   filepath - path to the file
% optional arguments:
% 'gridLayout'  - [rows, cols] - grid layout of the overview; if nothing given, the function will try to determine the best layout
% maxProject - if true, the function will create a maximum projection of the image, otherwise STD projection
% 'downsample' - downsample factor for the overview image; default is 0.5 (half size)

% parse input arguments
ip = inputParser;
ip.CaseSensitive = false;
addRequired(ip, 'filePath', @ischar);
addParameter(ip, 'gridLayout', [], @isnumeric);
addParameter(ip, 'maxProject', false, @islogical);
addParameter(ip, 'downsample', 0.5, @isnumeric);
parse(ip, filePath, varargin{:});

% dissect path, filename and extension from the filePath given as argument
[dataFolder, fileName, ext] = fileparts(filePath);

% read the file
[scenes, imageInfo] = importZeissStack(dataFolder, [fileName ext]);

if isempty(scenes)
    warning('Image was not loaded');
    R = 0;
    return;
end

if isempty(imageInfo)
    warning('Image metadata was not found, proceeding without scale information');
end

% create the overview
R = makeSlideOverviewPlot(scenes, 'metaData', imageInfo, 'gridLayout', ip.Results.gridLayout, 'maxProject', ip.Results.maxProject, 'downsample', ip.Results.downsample);



