function expressionMeasures = quantifyExpressionInStack(imageStack)
MAKEPLOTS = 0;
% Important: first make average of the stack, then do the histogram
% adjustment etc on the average, to reduce noise. 
% image should be in DOUBLE otherwise averaging etc will not work correctly
imageStack = im2double(imageStack);
[ysize xsize zsize] = size(imageStack);
avgSlice_raw = makeAverageSliceFromStack(imageStack);
GAMMA_BG = 0.9;
avgSlice = preprocessImageStack(avgSlice_raw, GAMMA_BG);
%avgSlice = makeAverageSliceFromStack(preprocessedStack);
bgMask = getBGmaskFromSlice(avgSlice);
sliceHull = bwconvhull(bgMask);

segTH_BG = 0.99;
expressionTH = 2;

imgQ = avgSlice;
imgQ(bgMask==0) = 0;

[segmented_image expressionFOUND expressionStrength expressionStrengthNorm] = getExpressionSegments(imgQ, bgMask, segTH_BG);

RGB_image_segmented = label2rgb(segmented_image, 'jet', [0 0 0]);
if (~expressionFOUND)
    disp('Expression below threshold, setting to nan');
    expressionMeasures.localization = nan;
    expressionMeasures.relativeExpressionArea = nan;
    expressionMeasures.bilaterality = nan;
    expressionMeasures.expressionStrength = nan;
    expressionSegmentImg = zeros(size(bgMask));
    expressionMeasures.expMaskImg = bgMask;
else

    %% relative area where something is expressed:
    expressionRegionStats = regionprops('table', segmented_image, 'Area');
    sliceAreaStats = regionprops('table',bgMask, 'Area');
    expressionRegionArea = expressionRegionStats.Area(end);
    sliceArea = sliceAreaStats.Area(end);

    expressionMeasures.relativeExpressionArea = expressionRegionArea / sliceArea;

    %% L / R similarity:

    segmented_image_L = imcrop(segmented_image, [0 0 xsize/2 ysize]);
    segmented_image_R = imcrop(segmented_image, [xsize/2 0 xsize/2 ysize]);

    Lstats = regionprops('table', segmented_image_L, 'Area');
    Rstats = regionprops('table', segmented_image_R, 'Area');

    if (height(Lstats) ~= height(Rstats))
        bilateralityMeasure = 0;
    else
        areaL = Lstats.Area(end);
        areaR = Rstats.Area(end);
        if areaL > areaR
        bilateralityMeasure = areaR / areaL;
        else
             bilateralityMeasure = areaL / areaR;
        end
    end

    expressionMeasures.bilaterality = bilateralityMeasure;

    %% localization near slice ventral border:
    % a new  binary image  with only the highest segment included:
    nRegions = height(expressionRegionStats.Area);
    expressionSegmentImg = zeros(size(segmented_image));
    expressionSegmentImg(segmented_image==nRegions) = 1;
    % average expression strength across vertical dimension
    vertImg = mean(expressionSegmentImg, 2, 'omitnan');
    % slice shape
    vertSlice = mean (sliceHull, 2, 'omitnan');

    sliceBottomY = ysize - find((flip(vertSlice) > 0), 1, "first");
    sliceTopY = find((vertSlice) > 0, 1, "first");
    croppedVertExp = vertImg(sliceTopY:sliceBottomY);
    croppedVertSlice = vertSlice(sliceTopY:sliceBottomY);

    expressionDistribution = cumsum(flip(croppedVertExp));
    expressionDistribution = expressionDistribution ./ max (expressionDistribution);

    sliceDistribution = cumsum(flip(croppedVertSlice));
    sliceDistribution = sliceDistribution ./ max (sliceDistribution);

    EXP_DIST_LIMIT = 0.90;

    expressionLimit = find(expressionDistribution>EXP_DIST_LIMIT, 1, 'first');
    relativeExpressionDistribution = expressionLimit / length(expressionDistribution);
    expressionMeasures.localization = 1-relativeExpressionDistribution;

    %% strength of expression

   expressionMeasures.expressionStrength = expressionStrengthNorm ./ 10;
  
   % The informative image showing BG mask and the expression region
   expressionMeasures.expMaskImg = bgMask+expressionSegmentImg;




end
if MAKEPLOTS
    figure; subplot (2, 2, 1); hold on;
    montage(imageStack);
    subplot (2, 2, 2); hold on;
    imshow(avgSlice, []);
    title ('Averaged z stack');
    subplot (2, 2, 3); hold on;
    imshowpair(expressionSegmentImg, bgMask, 'falsecolor');
    %       imshow(expressionSegmentImg, []);
    title ('Expression mask');
   subplot(2, 2, 4); hold on;
    if expressionFOUND
        
        plot(flip(vertImg), 'LineWidth', 2);
        expressionDistribution = cumsum(flip(croppedVertExp));
        expressionDistribution = expressionDistribution ./ max (expressionDistribution);
        plot(expressionDistribution);

        sliceDistribution = cumsum(flip(croppedVertSlice));
        sliceDistribution = sliceDistribution ./ max (sliceDistribution);
        plot(sliceDistribution);

        title('cumsum of expression, from slice ventral border');

        xlabel ('fraction');
        ylabel('pixels from slice ventral border');
        line([expressionLimit expressionLimit], [0 1], 'LineWidth', 2, 'LineStyle', '--');
        plot(expressionDistribution(1:expressionLimit), 'LineWidth', 2);
        plot(sliceDistribution(1:expressionLimit), 'LineWidth', 2);
        area(expressionDistribution(1:expressionLimit));
        area(sliceDistribution(1:expressionLimit));
        %        legend({'EXP', 'SLICE', 'expression Limit', 'AUC expression', 'AUC slice'}, 'Location', 'southeastoutside');
    
    else
        imshow(RGB_image_segmented, []);
    end

end