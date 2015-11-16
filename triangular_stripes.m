function Itri = triangular_stripes(I,peakgap);
%created 10_9_2015
%gaussian blur, extract peaks and antipeaks, and interpolate trangular profile between
%them.


% I = imread('H:\Mengfei_2015\Mengfei_2015_10_5\VE1.2_500fps\VE1.2_500fps0402.tif');
% I = imread('H:\Mengfei_2015\Mengfei_2015_10_7\VE0.8_V_500fps\VE0.8_V_500fps1678.tif');
% I = imread('H:\Mengfei_2015\Mengfei_2015_8_21\RCCW2_VE15_800_250_800_B500_3\stripes\verticalblur_findpeaks_V_60.tif');
I = double(I);
sizeI = size(I);
H = fspecial('gaussian',[50,50],1);
blurred = imfilter(I, H);
Itri = blurred;

for i = 1:sizeI(1)
    [peaks, locspeak] = findpeaks(blurred(i,:),'MinPeakDistance',peakgap);
    [peaks,locsbottom] = findpeaks(-blurred(i,:),'MinPeakDistance',peakgap);
%     locsbottom = interp1(1:length(locspeak),locspeak,1.5:1:length(locspeak));
    if numel(locspeak)*numel(locsbottom) ~= 0
        Itri(i,min(locspeak(1),locsbottom(1)):1:max(locspeak(end),locsbottom(end)))...
            = interp1([locspeak,locsbottom],[255*ones(1,length(locspeak)),zeros(1,length(locsbottom))],min(locspeak(1),locsbottom(1)):1:max(locspeak(end),locsbottom(end)));
    end
end
Itri = uint8(Itri);
% imwrite(uint8(Itri),'triangular_stripes_BG.tif')
% 
% % I = imread('H:\Mengfei_2015\Mengfei_2015_10_5\VE1.2_500fps\VE1.2_500fps0000.tif');
% % I = imread('H:\Mengfei_2015\Mengfei_2015_10_7\VE0.8_BG_500fps.tif');
% % I = imread('H:\Mengfei_2015\Mengfei_2015_8_21\RCCW2_VE15_800_250_800_B500_3\stripes\verticalblur_findpeaks_V_1.tif');
% I = double(I);
% sizeI = size(I);
% H = fspecial('gaussian',[500,500],4);
% blurred = imfilter(I, H);
% for i = 1:sizeI(1)
%     [peaks, locspeak] = findpeaks(blurred(i,:),'MinPeakDistance',peakgap);
%     [peaks,locsbottom] = findpeaks(-blurred(i,:),'MinPeakDistance',peakgap);
%     I(i,min(locspeak(1),locsbottom(1)):1:max(locspeak(end),locsbottom(end)))...
%         = interp1([locspeak,locsbottom],[255*ones(1,length(locspeak)),zeros(1,length(locsbottom))],min(locspeak(1),locsbottom(1)):1:max(locspeak(end),locsbottom(end)));
% end
% imwrite(uint8(I),'triangular_stripes_BG.tif')