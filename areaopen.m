function open = areaopen(I,size);
% I = imread('without_blurring.tif');
I = im2bw(I,0.5);%im2bw works on uint8

I = bwareaopen(I,size);%bwareaopen works on BW
open = 255*double(I);%transform 0-1bw to 0-255 double
% imwrite(uint8(I),'open.tif')%uint8 works on double
