function NLEVELS = findNLevelsForImage(img, metricTH)
if ~exist('metricTH', 'var')
    metricTH = 0.85;
end

nVals = 1:10;
for i = 1:length(nVals)
    warning("off"); 
    [thresh, metric(i)] = multithresh(img, nVals(i) );
    warning("on"); 
%    disp(['N = ' int2str(nVals(i)) '  |  metric = ' num2str(metric(i))]);
end

%using nLevels that is over 90%, or largest if that is not reached
metric(isinf(metric)) = nan;
thresholdLevelInd = find(metric>metricTH, 1, 'first');
if isempty(thresholdLevelInd)

    [maxMetric thresholdLevelInd ] = max(metric(~isinf(metric)));
    warning('Target level threshold not reached');
    NLEVELS = nVals(end);
else
    NLEVELS = nVals(thresholdLevelInd);
end
disp(['Thresholding BG with N = ' num2str(NLEVELS) ' levels,  with th target > ' num2str(metricTH)] );
