function I_v_h_blur = vertical_horizontal_average(I,iave,jave);
I = double(I);
I_v_h_blur = I;
% H = fspecial('gaussian',[5,5],5);
% I = imfilter(I,H);
sizeI = size(I);
num = 0;
for i = 1+iave : sizeI(1)-iave
    for j = 1+jave : sizeI(2)-jave
        I_v_h_blur(i,j) = mean(mean(I(i-iave:i+iave,j-jave:j+jave)));
    end
    fprintf(repmat('\b',1,num));
    percentage = 100*(i-iave)/(sizeI(1)-2*iave);
    msg = sprintf('%0.1f%% finished',percentage);
    num = numel(msg);
    fprintf('%0.1f%% finished',percentage)
end
imwrite(uint8(I_v_h_blur),'I_v_h_blur.tif');    
fprintf('\n')