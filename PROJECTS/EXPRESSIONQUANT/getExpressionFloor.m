function expressionRegionFloor = getExpressionFloor(img, expressionRegionMask)

imageNoise = std(img(expressionRegionMask == 1), 0, 'all', 'omitnan');
imageMean = mean(img(expressionRegionMask == 1), 'all', 'omitnan');

expressionRegionFloor = imageMean - imageNoise;
