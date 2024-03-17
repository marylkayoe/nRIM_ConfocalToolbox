function [meanCurliness, stdCurliness, semCurliness, curlyArray] = analyzeCurlinessForFile(filePath,fileName)
[imageStack, imageInfo] = importZeissStack(filePath, fileName);

[meanCurliness, stdCurliness, semCurliness, curlyArray] = measureCurlinessForStack(imageStack,imageInfo);

%plotBranches(imageStack,imageInfo, curlyArray);
end