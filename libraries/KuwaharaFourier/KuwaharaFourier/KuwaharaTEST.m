%% Test 2D  
I = repmat(I, 1*[1,1]);

% Small filter
kSize = 2*4+1;


tic; K1 = KuwaharaFast(I,(kSize-1)/4);  t1 = toc
tic; K2 = Kuwahara(I,kSize);  t2 = toc
tic; K3 = KuwaharaFourier3D(I,kSize); t3 = toc
A1 = K1;
figure; 
imagesc([I, K1,K2,K3;I, I-K1,I-K2,I-K3]); 
axis equal tight; colormap gray; 
title(['Original image, ', ...
    '          (', num2str(round(t1*100)/100), ' sec). '..., 
    '          (', num2str(round(t2*100)/100), ' sec). '..., 
    '          (', num2str(round(t3*100)/100), ' sec). '..., 
    ]);
set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[])
set(gcf,'color','w')
set(gca,'box','off')


% Large filter:  
kSize = 21*4+1;


tic; K1 = KuwaharaFast(I,(kSize-1)/4);  t1 = toc
tic; K2 = Kuwahara(I,kSize);  t2 = toc
tic; K3 = KuwaharaFourier(I,kSize); t3 = toc

figure; 
imagesc([I, K1,K2,K3;I, I-K1,I-K2,I-K3]); 
axis equal tight; colormap gray; 
title(['Original image, ', ...
    '          (', num2str(round(t1*100)/100), ' sec). '..., 
    '          (', num2str(round(t2*100)/100), ' sec). '..., 
    '          (', num2str(round(t3*100)/100), ' sec). '..., 
    ]);
set(gca,'xcolor','w','ycolor','w','xtick',[],'ytick',[])
set(gcf,'color','w')
set(gca,'box','off')

