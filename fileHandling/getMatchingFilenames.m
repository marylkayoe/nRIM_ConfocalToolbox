function fileNameList = getMatchingFilenames(dataFolder, varargin)
    % GETFILENAMELIST Get a list of file names in a folder that match the descriptors
    %   fileNameList = getFileNameList(dataFolder, varargin)
    %   Returns a cell array of file names in the folder dataFolder that match the
    %   descriptors in varargin. The descriptors are strings that must be present in the
    %   file name. If varargin is empty, all files in the folder are returned.
    %  Not all descriptors are necessary, those note given are treated as wildcards (*).
    % Descriptors are given as strings or char arrays.
    %
    % note this is a template function and you need to modify it for your own purpose.
    % in the template function, we expect the file names to be in the format of
    % EXPID-SLIDEID-SLICEID-OPTIONAL*.czi (ZEISS files).
    % note also that the default separator is hyphen (-). you can change it to any other
    % character with the SEPARATOR variable.
    %  Example: we want to get all files in the folder that have EXPID = 'GMD1' and SLIDEID = 'THT05',
    % the files are 20x magnification images. The magnification is an optional descriptor.
    % and the separator used in filenames is underscore (_). We can call the function as follows:
    %  fileNameList = getMatchingFilenames('path/to/folder', 'EXPID', 'GMD1', 'SLIDEID', 'THT05', 'OPTIONAL', '20x', 'SEPARATOR', '_');


    % Check if the folder exists
    if ~exist(dataFolder, 'dir')
        warningMessage = sprintf('Folder %s does not exist', dataFolder);
        warning(warningMessage);
        fileNameList = {};
        return
    end

    % parse inputs
    p = inputParser;
    addParameter(p, 'EXPID', '', @ischar);
    addParameter(p, 'SLIDEID', '', @ischar);
    addParameter(p, 'SLICEID', '', @ischar);
    addParameter(p, 'OPTIONAL', '', @ischar);
    addParameter(p, 'SEPARATOR', '-', @ischar);
    addParameter(p, 'EXTENSION', '.czi', @ischar);

    parse(p, varargin{:});

    % we will construct the pattern to be matched with in the variable searchString
    searchString = '';
    SEPARATOR = p.Results.SEPARATOR;
    % we flank the optional descriptors with wildcards
    OPTIONAL = ['*' p.Results.OPTIONAL '*'];

    if ~isempty(p.Results.EXPID)
        % if EXPID is given, we will add it to the search string
        searchString = [searchString, p.Results.EXPID];
    else
        % if EXPID is not given, we will add a wildcard (*) to the search string
        searchString = [searchString, '*'];
    end

    if ~isempty(p.Results.SLIDEID)
        % if SLIDEID is given, we will add it to the search string
        searchString = [searchString, SEPARATOR, p.Results.SLIDEID];
    else
        % if SLIDEID is not given, we will add a wildcard (*) to the search string
        searchString = [searchString, '*'];
    end

    if ~isempty(p.Results.SLICEID)
        % if SLICEID is given, we will add it to the search string
        searchString = [searchString, SEPARATOR, p.Results.SLICEID];
    else
        % if SLICEID is not given, we will add a wildcard (*) to the search string
        searchString = [searchString, SEPARATOR, '*'];
    end

    if ~isempty(p.Results.OPTIONAL)
        % if OPTIONAL is given, we will add it to the search string
        searchString = [searchString, SEPARATOR, OPTIONAL];
    else
        % if OPTIONAL is not given, we will add a wildcard (*) to the search string
        searchString = [searchString, SEPARATOR, '*'];
    end

    % add the extension to the search string
    searchString = [searchString, p.Results.EXTENSION];

    msg = sprintf('Searching for files with the pattern: %s in folder %s', searchString, dataFolder);
    disp(msg);

    % get the list of files in the folder
    fileList = dir(fullfile(dataFolder, searchString));
    fileNameList = {fileList.name};

    msg = sprintf('Found %d files matching the search terms.', length(fileNameList));
    disp(msg);
    %transpose the list to be in a column
    fileNameList = fileNameList';
end
