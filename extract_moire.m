function [I,withincircle]= extract_moire();
% I = imread('C:\users\Nagel lab\Desktop\Mengfei_2015_9_8\gaussian_infinite_moire_lens.tif');
I = imread('open_fast_infinite_moire_blur.tif');
I = double(I);
sizeI = size(I);

% radius = 2450.6/2;
% xcircle = 1626;
% ycircle = 1129.36;

radius = 1018/2;
xcircle = 808.50;
ycircle = 618.0;

% H = fspecial('gaussian',[50,50],4);
% I = imfilter(I, H);

for i = 1:sizeI(1)
    withincircle = zeros(1, sizeI(2));
    for  j = 1:sizeI(2)
        if (j-xcircle)^2+(i-ycircle)^2 < radius^2
            withincircle(j) = 1;
        end
    end
    within = find(withincircle);
    if isempty(within)
        continue
    end
    [peaks, locspeak] = findpeaks(I(i,find(withincircle)),'MinPeakDistance',20);
    locspeak = within(1)-1+locspeak;
    [peaks,locsbottom] = findpeaks(-I(i,find(withincircle)),'MinPeakDistance',20);
    locsbottom = within(1)-1+locsbottom;
    I(i,min(locspeak(1),locsbottom(1)):1:max(locspeak(end),locsbottom(end)))...
        = interp1([locspeak,locsbottom],[255*ones(1,length(locspeak)),zeros(1,length(locsbottom))],min(locspeak(1),locsbottom(1)):1:max(locspeak(end),locsbottom(end)));
end

imwrite(uint8(I),'extract_moire_9_26.tif')
