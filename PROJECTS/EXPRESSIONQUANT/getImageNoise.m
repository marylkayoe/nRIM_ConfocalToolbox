function imageNoiseLevel = getImageNoise(img, bgMask)

imageNoise = std(img(bgMask == 1), 0, 'all', 'omitnan');
imageMean = mean(img(bgMask == 1), 'all', 'omitnan');

imageNoiseLevel = imageMean + imageNoise;