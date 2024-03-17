function curlinessValues = measureCurlinessForSeries(dataFolder, seriesFileName)
    % reads in a czi file with multiple image stacks, gets the curliness measures for each and returns them in a vector
    % dataFolder: the folder containing the czi file
    % seriesFileName: the name of the czi file

    % read the metadata of the czi file with multiple stacks
    stackOMEdata = GetOMEData(fullfile(dataFolder, seriesFileName));
    % get the number of stacks
    numStacks = stackOMEdata.SeriesCount;
    % read stack images: 
    V = bfopen(fullfile(dataFolder, seriesFileName));
    V = V(:, 1); % drop extra info
    for seriesID = 1:numStacks
        sliceStack = cat(3, V{seriesID}{:, 1});
        disp (['Processing stack ' num2str(seriesID) ' ...']);

        % get the curliness measure for each stack
        curlinessValues(seriesID) = measureCurlinessForStack(sliceStack, stackOMEdata);
    end
    



