function R = makeSlideOverviewPlot(slideImageData, varargin)
%% this function will take image data opened from a CZI file
% and will  generate a collage image where each of the stacks in the slide data
% is presented by a single image.
% the single image is max projected (default) and then the images are arranged in a
% grid.
% the function will also return the image data for the collage image

% if no grid layout is given, the function will try to make a rectangle grid

% input data is a cell array, each cell contains the image data for a single stack

% parse input
p = inputParser;

% required input
p.addRequired('slideImageData', @(x) iscell(x));

% optional input
p.addParameter('maxProject', true, @islogical);
p.addParameter('gridLayout', [], @isnumeric);
p.addParameter('imageInfo', [], @isstruct)

% parse the input
p.parse(slideImageData, varargin{:});

nSLICES = length(slideImageData);

% make projection images
if p.Results.maxProject

    for i = 1:nSLICES
        adjustedImage = adjustHistogram(slideImageData{i});
        slideOverview{i} = max(adjustedImage, [], 3);
    end

else
    for i = 1:nSLICES
        adjustedImage = double(adjustHistogram(slideImageData{i}));
        slideOverview{i} = std(adjustedImage, 0, 3);
        %slideOverview{i} = mean(adjustedImage, 3);
    end


end

% make a grid layout
if isempty(p.Results.gridLayout)
    % try to make a rectangle grid
    nRows = floor(sqrt(nSLICES));
    nCols = ceil(nSLICES / nRows);
else
    nRows = p.Results.gridLayout(1);
    nCols = p.Results.gridLayout(2);
end

% make the collage image
R = zeros(size(slideOverview{1}, 1) * nRows, size(slideOverview{1}, 2) * nCols);

for slice = 1:nSLICES
    [row, col] = ind2sub([nRows, nCols], slice);
    R((row - 1) * size(slideOverview{1}, 1) + 1:row * size(slideOverview{1}, 1), (col - 1) * size(slideOverview{1}, 2) + 1:col * size(slideOverview{1}, 2)) = slideOverview{slice};

end
%
% show the image
figure;
imshow(R, []);

% add slice numbers
for slice = 1:nSLICES
    [row, col] = ind2sub([nRows, nCols], slice);
    text((col - 1) * size(slideOverview{1}, 2) + 10, (row - 1) * size(slideOverview{1}, 1) + 200, ['slice ' num2str(slice)], 'Color', 'r', 'FontSize', 20);
end

if isempty(p.Results.imageInfo)
else
    [xyResolution, zResolution] = getPixelResolution(p.Results.imageInfo);
    % draw scale bar at the bottom right of the image
    scaleBarLength = 500; % in microns
    scaleBarWidth = 100; % in pixels
    scaleBarStartX = size(R, 2) - 500 - scaleBarLength / xyResolution;
    scaleBarStartY = size(R, 1) - 200;
   
    %draw rectangle
    rectangle('Position', [scaleBarStartX, scaleBarStartY, scaleBarLength / xyResolution, scaleBarWidth], 'FaceColor', 'white', 'EdgeColor', 'r', 'LineWidth', 1);



    text(scaleBarStartX + scaleBarLength / xyResolution / 2, scaleBarStartY - 250, [num2str(scaleBarLength) ' \mum'], 'Color', 'r', 'FontSize', 20);


end

end
