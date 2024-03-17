function V = openSlideStacks(dataFolder, SLIDEID)

if (isunix)
    separator = '/';
else
    separator = '\';
end

fileName = makeSlideFileName(dataFolder, 'GMD1', SLIDEID);

%%check if we can find the file:
fileString =  [dataFolder separator fileName];
dirlist = dir (fileString);
if isempty(dirlist)

    warning(['File ' fileName ' not found on path ' dataFolder]);
else

    fileNames = dirlist.name;


    metaData = GetOMEData(fileString);
    disp(['Loading czi file ' fileName ' with ' num2str(metaData.SeriesCount) ' slices/series']);

    V = bfopen(fileString);
    V = V(:, 1); % drop extra info

 
end
