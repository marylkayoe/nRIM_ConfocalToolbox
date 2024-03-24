function THimage = makeThumbnailFromImageStack(imageStack, varargin)
    % makeThumbnailFromImageStack - make a thumbnail image from an image stack
    % e.g. confocal image stack, calcium image timeseries
    % the input data is 3D matrix, where the first two dimensions are the image and the third dimension is the Z or time
    % default: use STD intensity projection, otherwise specify method in varargin
    % default: use all frames, otherwise specify frame index in varargin
    % default: resulting size is 512x512 pixels, otherwise specify size in varargin

    % thumbnails will be 8-bit grayscale images and histogram adjusted for better visualization

    % example uses: 
    % generate 512x512 (default) thumbnail:
    % THimage = makeThumbnailFromImageStack(imageStack);

    % generate 256x256 thumbnail:
    % THimage = makeThumbnailFromImageStack(imageStack, 'newHeight', 256);

    %generate thumbnail with original aspect ratio (scaled down so that X dimension is 512 pixels):
    % THimage = makeThumbnailFromImageStack(imageStack, 'ratio', 'original');

    %generate thumbnail with original aspect ratio (scaled down so that X dimension is 256 pixels):
    % THimage = makeThumbnailFromImageStack(imageStack, 'ratio', 'original', 'sizeX', 256);

    % use mean intensity projection:
    % THimage = makeThumbnailFromImageStack(imageStack, 'method', 'mean');

    % only include middle frame:
    % THimage = makeThumbnailFromImageStack(imageStack, 'frameIndex', 'middle');

    % parse input arguments
    p = inputParser;
    %required input - image stack, 3D matrix
    addRequired(p, 'imageStack', @isnumeric);
    %optional input - method to make thumbnail, default is 'std'
    % other options 'mean', 'max', 'min'
    addParameter(p, 'method', 'std', @ischar);
    %optional input - frame index to use, default is 'all' frames
    % other options 'first', 'last', 'middle', 'random'
    addParameter(p, 'frameIndex', 'all', @ischar);
    %optional input - X size of thumbnail, default is 512 for 512x512 pixels
    addParameter(p, 'newHeight', [512], @isnumeric);
    %optional input - image ratio, default is 'square' for 1:1 aspect ratio, give 'original' for original aspect ratio
    addParameter(p, 'ratio', 'square', @ischar);

    parse(p, imageStack, varargin{:});

    % get the size of the image stack
    [height, width, numFrames] = size(imageStack);

    % if we are not taking all frames, select the frame
    if ~strcmp(p.Results.frameIndex, 'all')

        switch p.Results.frameIndex
            case 'first'
                frameIndex = 1;
            case 'last'
                frameIndex = numFrames;
            case 'middle'
                frameIndex = round(numFrames / 2);
            case 'random'
                frameIndex = randi(numFrames);
            otherwise
                warning('Invalid frame seletion, defaulting to "all frames"');
                frameIndex = 1:numFrames;
        end

    else
        frameIndex = 1:numFrames;
    end

    % select the frame(s) for thumbnailing
    imageStack = imageStack(:, :, frameIndex);

    % make the thumbnail image
    switch p.Results.method
        case 'std'
            % make sure the image stack is double
            if ~isa(imageStack, 'double')
                imageStack = double(imageStack);
            end

            % take the standard deviation intensity projection
            THimage = std(imageStack, [], 3);
        case 'mean'
            % take the mean intensity projection
            THimage = mean(imageStack, 3);
        case 'max'
            % take the max intensity projection
            THimage = max(imageStack, [], 3);
        case 'min'
            % take the min intensity projection
            THimage = min(imageStack, [], 3);
        otherwise
            warning('Invalid thumbnailing method, defaulting to "std"');
            % take the standard deviation intensity projection
            THimage = std(imageStack, [], 3);
    end

    % resize the thumbnail image

    sizeX = p.Results.newHeight;
    sizeY = p.Results.newHeight;


    if strcmp(p.Results.ratio, 'original')
            % figure out the original aspect ratio
        ratio = width / height;
        % figure out the new X and Y sizes based on sizeX
        % how much X will change from original:
        deltaX = sizeX - width;
        % how much Y size will change from original if aspect ratio is maintained:
        deltaY = deltaX / ratio;
        % new Y size
        sizeY = height + deltaY;
    end


        THimage = imresize(THimage, [sizeY sizeX]);

    % normalize the image and convert to RGB
    THimage = mat2gray(THimage);
    THimage = repmat(THimage, [1 1 3]);
end
