function THmontage = makeThumbnailMontage(THimageArray)
% generates a montage image of the thumbnails in THimageArray
% arranged in rectangular grid

% input: THimageArray: cell array of thumbnail images, they are assumed to be the same size
% and only one channel

% Get the size of the images
[height, width, ~] = size(THimageArray{1});
nIMAGES = length(THimageArray);

nRows = floor(sqrt(nIMAGES));
nCols = ceil(nIMAGES / nRows);

% Initialize the output image
THmontage = zeros(height * nRows, width * nCols, 'like', THimageArray{1});



% Fill the output image
for i = 1:nRows

    for j = 1:nCols
        % Calculate the current index in the cell array
        index = (i - 1) * nCols + j;

        % Check if this index exists in the cell array
        if index <= numel(THimageArray)
            % Calculate the row and column ranges for this image
            rowRange = (i - 1) * height + 1:i * height;
            colRange = (j - 1) * width + 1:j * width;

            %convert the RGB THimage to grayscale
            if size(THimageArray{index}, 3) == 3
                THimageArray{index} = rgb2gray(THimageArray{index});
            end

            % Add the image to the output image
            THmontage(rowRange, colRange) = THimageArray{index};
        end

    end

end

end
