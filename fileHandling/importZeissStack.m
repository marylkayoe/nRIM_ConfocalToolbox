function [scenes, OMEdata] = importZeissStack(dataPath, fileName, varargin)
%% IMPORTZEISSSTACK imports a Zeiss LSM image stack based on bioformats toolboxes.
%%
%% Input: path to the image file, filename; optional: channel to import
%% Output: image stack as a SINGLE 3D matrix; if channel is specified, only the specified channel is imported.
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

scenes = [];
OMEdata = [];

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
OMEdata = GetOMEData(fileString);
nImagesInStack = OMEdata.SizeZ;
nSCENES = OMEdata.SeriesCount;
nImagesTotal = nImagesInStack * nSCENES;

disp(['Loaded czi file ' fileName ' with ' num2str(nSCENES) ' slices/series']);
images = data{1}(:, 1); % keep only the image data

% segreagte the images into appropriate stacks (per scene) 


% reformat into cell array for easier handling later
scenes = cell(1, nSCENES);
for i = 1:nSCENES
  scenes{i} = cat(3, data{i}{:, 1});
end





