function SLIDEID = getSlideIDfromFilename(fileName)
    % getSlideIDfromFilename - get the slide ID from the filename
    %   SLIDEID = getSlideIDfromFilename(fileName)
    % confocal filenames are assumed to be of form:
    % EXPID_SLIDEID_*.* or EXPID-SLIDEID_*.*
    % e.g. characters up to the second separator is SLIDEID
    %
    % Inputs:
    %   fileName - the filename of the slide
    %
    % Outputs:
    %   SLIDEID - the slide ID
    %
    % use: SLIDEID = getSlideIDfromFilename('GMD1-THT04-SLICE9-40x2x-singlestack-pos4');
    % returns 'GMD1-THT04'

    % validate input (should be string of the form 'EXPID_SLIDEID_*.*') or ('EXPID-SLIDEID_*.*')
    
    SLIDEID = 'SLIDE0';

    if ~ischar(fileName)
        warning('getSlideIDfromFilename:invalidInput', 'Input must be a string');
        return;
    end

    fileName = cleanUnderscores(fileName); % replaces underscores with hyphens

    %find second hyphen in fileName
    hyphenPos = strfind(fileName, '-');
    if isempty(hyphenPos)
        warning('No SLIDEID identified, check filename formatting EXPID-SLIDEID-*.*');
        return;
    end

    % get slide ID
    SLIDEID = fileName(1:hyphenPos(2)-1);
end





