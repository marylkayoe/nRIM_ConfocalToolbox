function bgMask = segmentBGfromSlice(img)
% returns mask where background = 0, slice = 1

NLEVELS = 12;
% test here how many levels are needed
% noisy images need more
% Nvals = [1 2 4 8 10 12 15 20];
% for i = 1:length(Nvals)
%     [thresh, metric] = multithresh(img, Nvals(i) );
%     disp(['N = ' int2str(Nvals(i)) '  |  metric = ' num2str(metric)]);
% end

thresh = multithresh(img, NLEVELS);
labeledIMAGE = imquantize(img,thresh);
segmentedImage = img;
segmentedImage(labeledIMAGE==1) = 0;
bgMask = segmentedImage; 
bgMask (segmentedImage>0) = 1;

% labeledIMAGE(labeledIMAGE==1) = 0;
% histogram(segIMAGE);

% RGB = label2rgb(labeledIMAGE, 'jet', [0 0 0]); 
% figure;
% imshow(RGB);