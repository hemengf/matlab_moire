function [Iedge,threshOut] = edge_detect(P);
warning('off','all')
I = double(P);
sizeI = size(I);
H = fspecial('gaussian',[10,10],4);
I = imfilter(I,H);
ave = 2;
num = 0;
Iverti = I;
Iverti_sgolay = I;
fprintf('\nAveraging vertically... ')
for j = ave+1:sizeI(1)-ave
    Iverti(j-ave,:) = mean(I(j-ave:j+ave,:));
    fprintf(repmat('\b',1,num));
    percentage = 100*j/(sizeI(1)-ave);
    msg = sprintf('%0.3f%% finished',percentage);
    num = numel(msg);
    fprintf('%0.3f%% finished',percentage)
end

for i = 1:sizeI(1)
    Iverti_sgolay(i,:) = sgolayfilt(Iverti(i,:),3,11);
end

fprintf('\n')
[Iedge,threshOut] = edge(Iverti_sgolay,'Canny',[0.01,0.1]);
Iedge = bwareaopen(Iedge,10);
Iedge = 255*uint8(Iedge);
imwrite(Iedge,'IedgeV.tif')
winopen('IedgeV.tif')