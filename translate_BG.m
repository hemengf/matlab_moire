function translate_BG(BG,total_pixels,step_pixels);
% function called: 

%translate in x direction BG and save in a folder
%2015_10_29
BG = double(BG);
num = 0;
for i = 1:total_pixels
    BG = imtranslate(BG,[step_pixels,0]);
    imagestring = sprintf('H:\\Mengfei_2015\\Mengfei_2015_10_29\\result_snapshot1\\no_shrinking_patches\\BG\\translate_BG\\BG_translated_%d_pixels.tif',i*step_pixels);
    imwrite(uint8(BG),imagestring,'tif')
    
    fprintf(repmat('\b',1,num));
    percentage = 100*(i)/(total_pixels);
    msg = sprintf('%0.0f%% finished;',percentage);
    num = numel(msg);
    fprintf('%0.0f%% finished;',percentage)
end
fprintf('\n')