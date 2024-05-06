%a function that will take one mapping image file, make a std plot of it, then draw on it rectangles of the locations of the stacks in the stacks file
function R = mapStacksToMap(dataFolder, mapFileName, stacksFileName, Xtiles, Ytiles, zoomFactor, curlyVals)
[mapImageStack, imageInfo] = importZeissStack(dataFolder, mapFileName);
figure; hold on;
imshow(max(mapImageStack, [], 3), []);
mapCenterXum = imageInfo.ImageCenterX;
mapCenterYum = imageInfo.ImageCenterY;

mapPixelSize = imageInfo.ScaleX;
[mapSizeX, mapSizeY] = size(mapImageStack(:,:,1));

% size of map image in um
mapUmSizeX = mapSizeX * mapPixelSize;z
mapUmSizeY = mapSizeY * mapPixelSize;
%
mapOriginXum = floor(mapCenterXum - (mapUmSizeX/2));
mapOriginYum = floor(mapCenterYum + (mapUmSizeY/2));

stackOMEdata = GetOMEData(fullfile(dataFolder, stacksFileName));

stackPixelSizeX = stackOMEdata.ScaleX;

stackSizeX = stackOMEdata.SizeX /(zoomFactor/2);
stackSizeY = stackOMEdata.SizeY /(zoomFactor/2);

stackSizeXum = stackSizeX * stackPixelSizeX;
stackSizeXMap = floor(stackSizeXum  / mapPixelSize);
stackSizeYum = stackSizeY * stackPixelSizeX;
stackSizeYMap = floor(stackSizeYum  / mapPixelSize);

nStacks = length(stackOMEdata.ImageIDs);

% adjust coordinates relative to map origin and scale
for s = 1:nStacks
    stackXcornerUm(s) = (stackOMEdata.ImageCenterX(s) - (stackSizeXum) ); % in um
    stackYcornerUm(s) = (stackOMEdata.ImageCenterY(s) - (stackSizeYum));

    stackMapCoordXUm(s) = stackXcornerUm(s) - mapOriginXum;
    stackMapCoordYUm(s) = stackYcornerUm(s) - mapOriginYum  ;

    stackMapCoordX(s) =  ceil(stackMapCoordXUm(s) / mapPixelSize) ;
    stackMapCoordY(s) =  ceil(stackMapCoordYUm(s) / mapPixelSize);
end
% Define the colormap
% Create colormap
%cmap = cool(512);
cmap = gray(512);

% Determine color indices based on the curliness values
cind = round(interp1(linspace(min(curlyVals), max(curlyVals), size(cmap, 1)), 1:size(cmap, 1), curlyVals, 'linear', 'extrap'));

% Limit color indices to valid range
cind(cind < 1) = 1;
cind(cind > size(cmap, 1)) = size(cmap, 1);




for s = 1:nStacks
    r = rectangle('Position',[ stackMapCoordX(s) + mapSizeY/Xtiles + stackSizeXMap  ,  -stackMapCoordY(s) - mapSizeX/Ytiles - stackSizeXMap, stackSizeXMap, stackSizeYMap],'EdgeColor', 'white', 'FaceColor',[cmap(cind(s), :) 0.7], 'LineWidth',1);
 %   t = text(stackMapCoordX(s) + mapSizeY/Xtiles + stackSizeXMap , -stackMapCoordY(s) - mapSizeX/Ytiles - stackSizeXMap/2, num2str(s), 'Color', 'white', 'FontSize',12);
end
% Add colorbar
% create a colorbar for the rectangle face colors only
figure; hold on;
c = colorbar('peer', gca);
caxis([min(curlyVals), max(curlyVals)]); % set the color range
colormap(gca, cmap); % set the colormap
R = 1;
end



