function tiffStack = importTiffStack(dataFolder, filename)
    % Import tiff image Stack into a 3D matrix
    %
    % Parameters:
    % dataFolder - Path to the folder containing the TIFF file
    % filename - Path to the TIFF file
    %
    % Returns:
    % tiffStack - A 3D matrix containing the adjusted TIFF stack

    fullFileName = fullfile(dataFolder, filename);

    % Check if the file exists
    if ~exist(fullFileName, 'file')
        error('File does not exist: %s', filename);
    end

    % Validate that the file is a TIFF
    [~, ~, ext] = fileparts(filename);
    if ~strcmpi(ext, '.tif') && ~strcmpi(ext, '.tiff')
        error('The file is not a TIFF image.');
    end

    % Read the TIFF file
    tiffInfo = imfinfo(fullFileName); % Get information about the TIFF file
    numFrames = numel(tiffInfo);  % Number of frames in the stack
    firstFrame = imread(fullFileName, 1); % Read the first frame to get dimensions
    [rows, cols] = size(firstFrame);

    % Initialize the stack
    tiffStack = zeros(rows, cols, numFrames, 'double');
disp(['Importing TIFF stack...' filename]);
    % Import each frame, display . for every 100 frames
    for i = 1:numFrames
         tiffStack(:,:,i) = imread(fullFileName, i); % Read each frame
            if mod(i, 100) == 0
                fprintf('.');
            end
    end
    fprintf('\n');
    

end
