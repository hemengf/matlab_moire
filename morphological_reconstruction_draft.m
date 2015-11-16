%% open: remove white
figure
se = strel('disk',5);
Co = imopen(uint8(C),se);
subplot(1,2,1)
imshow(C)
title('original')
subplot(1,2,2)
imshow(Co)
title('disk5,open')
imwrite(Co,'Co.tif');

%% close: remove black
se = strel('disk',5);
Cc = imclose(uint8(C),se);
figure
subplot(1,2,1)
imshow(C)
subplot(1,2,2)
imshow(Cc)
title('disk5,close')
imwrite(Cc,'Cc.tif')
%% erode: increase black
se = strel('disk',5);
Ce = imerode(uint8(C),se);
figure,imshow(Ce)
title('disk5,erode')
imwrite(Ce,'Ce.tif')
%% dilate: increase white
se = strel('disk',5);
Cd = imdilate(uint8(C),se);
figure,imshow(Cd)
title('disk5,dilate')
imwrite(Cd,'Cd.tif')
%% erode reconstruct: highlight white part
se = strel('disk',10);
Ce = imerode(C,se);
Cer = imreconstruct(Ce,C);
figure
subplot(1,2,1)
imshow(C)
subplot(1,2,2)
imshow(Cer)
title('disk5,erode_reconstruct')
imwrite(Cer,'Cer.tif')
%% dilate reconstruct: nothing; marker outside mask
se = strel('disk',5);
Cd = imdilate(C,se);
Cdre = imreconstruct(Cd,C);
figure
subplot(1,2,1)
imshow(C)
subplot(1,2,2)
imshow(Cdre)
title('disk5,dilate_reconstruct')

%% open and close
seo = strel('disk',10);
Co = imopen(uint8(C),seo);
sec = strel('disk',10);
Coc = imclose(Co,sec);
figure
subplot(2,2,1)
imshow(Co)
title('open')
subplot(2,2,2)
imshow(Coc)
title('open and close')
Ccocrec = imreconstruct(Coc,C);
subplot(2,2,3)
imshow(Ccocrec)
title('open close reconstruct')
%%
se = strel('disk',2);
Ce = imerode(C,se);
Cer = imreconstruct(Ce,C);
figure
subplot(2,2,1)
imshow(C)
subplot(2,2,3)
imshow(Cer)
title('disk5,erode reconstruct')
Cerd = imdilate(Cer,se);
C_recons = imreconstruct(imcomplement(Cerd),imcomplement(Cer));
C_recons = imcomplement(C_recons);
C_recons2 = imreconstruct(Cerd,Cer);
subplot(2,2,4)
imshow(C_recons)
title('reconstruct from erd and er')
subplot(2,2,2)
imshow(C_recons2)
title('no complement')
imwrite(C_recons,'C_reconsBG.tif');
winopen('C_reconsBG.tif')
%%
thinBW1 = im2bw(thin(:,1:579),0.27);
thinBW2 = im2bw(thin(:,580:1632),0.37);
thinBW = [thinBW1,thinBW2];
figure
thinBW = 255*uint8(thinBW);
imshow([thinBW1,thinBW2])
imwrite(thinBW,'thinBW.tif')
se = strel('disk',10);
thinBW_e = imerode(thinBW,se);
imwrite(thinBW_e,'thinBW_e.tif')
figure
imshow(thinBW_e)
thinBW_e_r = imreconstruct(thinBW_e,thin);
figure
imshow(thinBW_e_r)
imwrite(uint8(thinBW_e_r),'thinBW_e_r.tif')







