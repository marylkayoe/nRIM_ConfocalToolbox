function fileName = makeSlideFileName(dataFolder, EXPID, SLIDEID, SPEC, FILETYPE)
    % this function takes the data folder, experiment ID, slide ID and additional specificiation strings
    % and returns the filename of the slide image
    % a search pattern is generated from the information 
    % and the first filename that matches the pattern is returned


% if no specificiation string is given, assume that the image is a .czi file
if (~exist('SPEC', 'var'))
    SPEC = '';
end

if (~exist('FILETYPE', 'var'))
    FILETYPE = '*.czi';
end

% depending on the operating system, the separator is different
if (isunix)
    separator = '/';
else
    separator = '\';
end

FILEMASKSTRING = [EXPID '-' SLIDEID '*' SPEC '*' FILETYPE];

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