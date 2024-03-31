function fileName = generateFilenameFromExpDescriptors(varargin)
% generateFilenameFromExpDescriptors - generate a filename from the experiment descriptors
% the input must contain the experiment ID and minimally filetype
% varargin will contain name-value pairs for other descriptors
% example use:
% generateFilenameFromExpDescriptors('EXPID', 'GMD02', 'filetype', '.csv', 'MOUSEID', 'M032', 'GROUPID', 'CTRL');
% 
% NOTE: you must modify this function to include the descriptors you want to be included 
% in the filename, and in the right order.
%
% Currently the function will generate a filename with the following format from the input as in the above example:
%
% EXPID_MOUSEID_GROUPID.filetype 
%
% so, for the above example, the filename will be:
% EXPID_M032_CTRL.csv
%
% if you want to change the format, you must modify this function by adjusting the input parsing and filename generation


% check input variables (need at least 2 arguments)

fileName = '';

% parse the input arguments
p = inputParser;

% you need to give at least EXPID and filetype
% the "@ischar" tells the parser that the input must be a string, and you will get an error if it is not
% this is a nice way to check the input arguments' type as well as existence
addRequired(p, 'EXPID', @ischar);
addRequired(p, 'filetype', @ischar);

% add optional arguments
addParameter(p, 'MOUSEID', '', @ischar);
addParameter(p, 'GROUPID', '', @ischar);
% character used to separate the descriptors in the filename, default is '-'
addParameter(p, 'separator', '-', @ischar);

% parse the input
parse(p, varargin{:});

if isempty(p.Results.EXPID) || isempty(p.Results.filetype)
    error('You must provide at least EXPID and filetype');
end

EXPID = p.Results.EXPID;

% add the separator characer before the other descriptor strings
if ~isempty (p.Results.MOUSEID)
    MOUSEID = [p.Results.separator p.Results.MOUSEID];
    % so if MOUSEID was 'M032', it will be '-M032' (with the default dash separator)
else
    MOUSEID = '';
end
if ~isempty (p.Results.GROUPID)
    GROUPID = [p.Results.separator p.Results.GROUPID];
    % so if GROUPID was 'CTRL', it will be '-CTRL' (with the default dash separator)
else
    GROUPID = '';
end

% check if the filetype is correctly formatted, should be '.' followed by the extension
% if not, add the . to the filetype
% this way you can give the filetype as 'csv' or '.csv' and it will work

if p.Results.filetype(1) ~= '.'
    filetype = ['.' p.Results.filetype];
else
    filetype = p.Results.filetype;
end

% generate the filename from the descriptors
% you can modify this to include more descriptors or change the order
fileName = [EXPID  MOUSEID GROUPID filetype];

end




