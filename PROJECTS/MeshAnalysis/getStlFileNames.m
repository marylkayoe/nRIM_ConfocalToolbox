function [stlFileNames] = getStlFileNames(dataFolder, searchString)

if (~exist('searchString', 'var'))
    searchString = '*.stl';
end

if (isunix)
    separator = '/';
else
    separator = '\';
end


searchString =  [dataFolder separator searchString];
dirlist = dir (searchString);
stlFileNames = vertcat({dirlist.name});
end

