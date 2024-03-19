function [laserWL, laserPower, zoomInfo, dateInfo] = getZeissMetadata(metadata)
    % getZeissMetadata - extract metadata from the metadata section of a zeiss image file
    % the metadata information is in the form of a hashtable
    % note that the values are strings and need to be converted to numbers
    % also: currently this only works correctly for files with a single channel

    % initialize return variables
    laserWL = [];
    laserPower = [];
    zoomInfo = [];
    dateInfo = [];

    % check if metadata is a hashtable
    if ~isa(metadata, 'java.util.Hashtable')
        warning('metadata is not a java.util.Hashtable, returning empty metadata');
        return
    end

    % Find all the keys in the metadata:
    keys = metadata.keySet().toArray();

    % how many keys there are
    nKEYS = length(keys);

    % initialize a cell array to store the key strings
    % size: nKEYS rows, 1 column

    keystrings = cell(nKEYS, 1);

    %loop through the keys and store the strings in the cell array
    for i = 1:nKEYS
        keystrings{i} = keys(i);
    end

    % find the key for the zoom information
    % 1. find all the keys that contain the word 'ZoomX'
    zoomKeys = cellfun(@(x) contains(x, 'ZoomX'), keystrings);
    % 2. find the index of the first key that contains the word 'ZoomX'
    zoomKeyIndex = find(zoomKeys, 1);

    if isempty(zoomKeyIndex)
        warning('No zoom information found in metadata');

    else
        % 3. get the key string
        zoomKey = keystrings{zoomKeyIndex};
        % 4. get the value of the key
        zoomInfoStr = metadata.get(zoomKey);
        % 5. convert the value to a number
        zoomInfo = str2num(zoomInfoStr);
    end

    % same for laser power
    laserPowerKeys = cellfun(@(x) contains(x, 'LaserPower'), keystrings);
    laserPowerKeyIndex = find(laserPowerKeys, 1);

    if isempty(laserPowerKeyIndex)
        warning('No laser power information found in metadata');
    else

        laserPowerKey = keystrings{laserPowerKeyIndex};
        laserPowerStr = metadata.get(laserPowerKey);
        laserPower = str2num(laserPowerStr);
    end

    % same for laser wavelength
    laserWLKeys = cellfun(@(x) contains(x, 'Wavelength'), keystrings);
    laserWLKeyIndex = find(laserWLKeys, 1);

    if isempty(laserWLKeyIndex)
        warning('No laser wavelength information found in metadata');
    else
        laserWLKey = keystrings{laserWLKeyIndex};
        laserWLStr = metadata.get(laserWLKey);
        laserWLm = str2double(laserWLStr); % this is in meters :)
        laserWL = round(laserWLm * 1e9); % convert to nm
    end

    % same for date created
    dateKeys = cellfun(@(x) contains(x, 'CreationDate'), keystrings);
    dateKeyIndex = find(dateKeys, 1);

    if isempty(dateKeyIndex)
        warning('No date information found in metadata');
    else
        dateKey = keystrings{dateKeyIndex};
        dateInfo = metadata.get(dateKey);
        % in the date string, we want to extract the date only
        % we want to extract the date only by splitting at 'T'
        dateInfo = strsplit(dateInfo, 'T');
        dateInfo = dateInfo{1};
        % timeInfo = dateInfo{2};
    end

end
