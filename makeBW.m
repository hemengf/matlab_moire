function makeBW(I,bwlevel);
% I = imread('H:\Mengfei_2015\Mengfei_2015_10_5\VE1.2_500fps\VE1.2_500fps0402.tif');
I = double(I);
H = fspecial('gaussian',[100,100],4);
blurred = imfilter(I, H);
imwrite(uint8(blurred),'blurred_before_bw.tif')
I = uint8(blurred);
I = im2bw(I,bwlevel);
I = 255*double(I);
I = uint8(I);
imwrite(I,'makeBW_V.tif')
winopen('blurred_before_bw.tif')
winopen('makeBW_V.tif')