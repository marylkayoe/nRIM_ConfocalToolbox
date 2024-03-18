function [scenes, imageInfo] = importZeissStack(dataPath, fileName, varargin)
%% IMPORTZEISSSTACK imports a Zeiss LSM image stack based on bioformats toolboxes.
%%
%% Input: path to the image file, filename; optional: channel to import
%% Output: scenes: image stacks
%%         imageInfo: a structure containing the image information from file metadata
% Note: currently metadata is given for first image with the assumption
% that everything is same in all scenes
%% check input

if nargin < 2
    error('Please specify the path and filename.');
end

if nargin > 2
    channel = varargin{1};
else
    channel = 0;
end

scenes = [];
imageInfo = [];

% create full file path from dataPath and fileName
fileString = fullfile(dataPath, fileName);

% check if file exists
if ~exist(fileString, 'file')
    warning(['File ' fileString ' not found, aborting import.']);
    return;
end

%% import image stack using bfopen
[data] = bfopen(fileString);

% check if the data is empty
if isempty(data)
    warning(['No data found in file ' fileString ', aborting import.']);
    return;
end

% read metadata to find out how many scenes / positions there are
imageInfo = GetOMEData(fileString);
[laserWL, laserPower, zoomInfo] =  getZeissMetadata(data{1, 2}); % the Zeiss-specific data are here
imageInfo.zoom = zoomInfo;
imageInfo.LaserPower = laserPower;
imageInfo.LaserWL = laserWL;

nImagesInStack = imageInfo.SizeZ;
nSCENES = imageInfo.SeriesCount;
nImagesTotal = nImagesInStack * nSCENES;

disp(['Loaded czi file ' fileName ' with ' num2str(nSCENES) ' slices/series']);
images = data{1}(:, 1); % keep only the image data

% segreagte the images into appropriate stacks (per scene) 


% reformat into cell array for easier handling later
scenes = cell(1, nSCENES);
for i = 1:nSCENES
  scenes{i} = cat(3, data{i}{:, 1});
end





