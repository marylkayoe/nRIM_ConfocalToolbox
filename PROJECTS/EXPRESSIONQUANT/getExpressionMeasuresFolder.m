function [meanExpressionData stdExpressionData slideExpressionData expressionVolumes SLIDEIDS expressionMeasures expressionVolumeIMG] = getExpressionMeasuresFolder(dataFolder)

EXCLUDE_NONEXPRESSING = 0;

if (isunix)
    separator = '/';
else
    separator = '\';
end

dirlist = dir ([dataFolder separator '*.czi']);
fileNames = {dirlist.name};

if isempty(fileNames)
    disp('No czi files found');
    R = 0;
else
    nSLIDES = length(fileNames);


    for slide = 1:nSLIDES
        cziFileName = fileNames{slide};
        SLIDEIDS{slide} = getSlideIDfromFilename(cziFileName);
        SLICEIDS = extractSliceIDsFromFileName(cziFileName);

        [slideExpressionData{slide} expressionMeasures expressionVolumes(slide) expressionVolumeIMG{slide}] = quantifyExpressionInSlide(cziFileName, dataFolder, SLICEIDS);
    end
    %% show mean values of all the measures
    nSLIDES = length(slideExpressionData);
    [nSLICES nMEASURES] = size(slideExpressionData{1});
    meanExpressionData = nan(nSLIDES, nMEASURES);
    stdExpressionData = nan(nSLIDES, nMEASURES);
    for s = 1:nSLIDES
        meanExpressionData(s, :) = mean (slideExpressionData{s}, 'omitnan');
        stdExpressionData(s, :) = std (slideExpressionData{s}, 0, 1, 'omitnan');
    end
    figure;
    if (find(~isnan(meanExpressionData)))
        violinplot([meanExpressionData expressionVolumes'], {'Area' 'bilaterality' 'localization' 'strength' 'volume'});
        title ('means of individual slides/brains');
    end
    %% show per-slice measures

    maxNSlices = max (cellfun(@length, slideExpressionData));
    measureMat = nan(maxNSlices, nSLIDES, nMEASURES);
    for m = 1:nMEASURES
        for s = 1:nSLIDES
            slideData = slideExpressionData{s};
            [nSLICES nM] = size(slideData);
            measureMat(1:nSLICES, s, m) = slideData(:, m);

        end
    end

    figure;

    for m = 1:nMEASURES
        subplot(nMEASURES+1, 1, m); hold on;

        toPlot = squeeze(measureMat(:, :, m));
        if(find(~isnan(toPlot)) & find(~isempty(toPlot)))
            %    toPlot(isnan(toPlot)) = -0.01;
            violinplot(toPlot, SLIDEIDS);
            title(expressionMeasures{m});
            axis tight;
        end


    end
    subplot(nMEASURES+1, 1, 3);
    ylim([0 1]);

    subplot(nMEASURES+1, 1, 2);
    ylim([0 1]);

    subplot(nMEASURES+1, 1, 4);
    ylim([0 0.5]);
    set(gca, 'YScale', 'log');

    subplot(nMEASURES+1, 1, m+1);
    scatter(1:nSLIDES, expressionVolumes, 'filled');
    title ('Expression volume');
    xticklabels(SLIDEIDS);


    figure; % plotting here the clustering results
    subplot(1, 2, 1); hold on;
    expressionSamples = meanExpressionData;
    [score, clusterIndices] = LF_makeClusterPlot(expressionSamples);

    title("First 2 PCA Components of Clustered Data with negative samples included");


    subplot(1, 2, 2); hold on;
% 
%     expressingSampleIdx = find(mean(meanExpressionData')); % this returns those that are not 0
%     expressionSamplesNoNeg = meanExpressionData(expressingSampleIdx, :);
normExpressionData = normalize(meanExpressionData);
    [scoreNN, clusterIndicesNN] = LF_makeClusterPlot(normExpressionData);
    title("First 2 PCA Components of Clustered Data with normalized data ");

% 
%     SLIDEIDS = SLIDEIDS(expressingSampleIdx);
%     for c = 1:length(unique(clusterIndicesNN));
%         disp (['Samples in cluster ' num2str(c) ': ' [SLIDEIDS{clusterIndicesNN==c}]]);
%     end



    R = 1;
end

function [score, clusterIndices] = LF_makeClusterPlot(expressionSamples)

    % Select optimal number of clusters (K value) using specified range
    fh = @(X,K)(kmeans(X,K));
    eva = evalclusters(expressionSamples,fh,"CalinskiHarabasz","KList",2:6);
    clear fh
    K = eva.OptimalK;
    clusterIndices = eva.OptimalY;

    % Calculate centroids
    centroids = grpstats(expressionSamples,clusterIndices,"mean");

    % Display results

    % Display 2D scatter plot (PCA)
    [~,score] = pca(expressionSamples);
    clusterMeans = grpstats(score,clusterIndices,"mean");
    h = gscatter(score(:,1),score(:,2),clusterIndices,colormap("lines"), '.' , 40);
    for i2 = 1:numel(h)
        h(i2).DisplayName = strcat("Cluster",h(i2).DisplayName);
    end
    %   clear h i2 score
    hold on
    h = scatter(clusterMeans(:,1),clusterMeans(:,2),50,"kx","LineWidth",2);
    hold off
    h.DisplayName = "ClusterMeans";
    %  clear h clusterMeans
    legend;
    xlabel("First principal component");
    ylabel("Second principal component");
