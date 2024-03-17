function SLIDEID = getSlideIDfromFilename(filename)
%SLIDEID should be the string between first and second underscore

delimitpos = strfind(filename, '_');
SLIDEID = filename(delimitpos(1)+1 : delimitpos(2)-1);
