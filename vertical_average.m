function [Iverti] = vertical_average(I,ave)
I = double(I);
sizeI = size(I);
num = 0;

for j = ave+1:sizeI(1)-ave
    Iverti(j-ave,:) = mean(I(j-ave:j+ave,:));
    fprintf(repmat('\b',1,num));
    percentage = 100*j/(sizeI(1)-ave);
    msg = sprintf('%0.3f%% finished',percentage);
    num = numel(msg);
    fprintf('%0.3f%% finished',percentage)
end

fprintf('\n')
imwrite(uint8(Iverti),'Iverti.tif')
winopen('Iverti.tif')