function fileName = makeSlideFileName(dataFolder, EXPID, SLIDEID, IMGTYPE)
% find the filename in a folder containing SLIDEID
%IMGTYPE can be used to specify versions if applicable
if (~exist('IMGTYPE', 'var'))
    IMGTYPE = '10x06x_overviews';
end

if (isunix)
    separator = '/';
else
    separator = '\';
end

FILEMASKSTRING = [EXPID '-' SLIDEID '*' IMGTYPE '*.czi'];

    searchString =  [dataFolder separator FILEMASKSTRING];
    dirlist = dir (searchString);
    if isempty(dirlist)
        warning ('No matching files found!');
        fileName = '';
        return;
    end
    if length(dirlist) > 1
        warning(['more than one file matches pattern ' searchString ', taking first of them']);
    end
    fileName = dirlist(1).name;
end