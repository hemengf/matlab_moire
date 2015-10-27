function [index2,Irec] = singlestripeextraction(I, istart, iend, jstart, jend);
% warning('off','all')
% I = imread('C:\users\Nagel lab\Desktop\scanBG0007.tif');
I = double(I);
sizeI = size(I);
H = fspecial('gaussian',[15,5],4);
I = imfilter(I, H);
Irec = 255*ones(sizeI);
Iverti = zeros(sizeI);
ave = 1;
num = 0;
index = zeros(sizeI(1),1);
index2 = zeros(sizeI(1),1);

% fprintf('\nAveraging vertically...')
% for i = 100:2385-ave
%     Iverti(i,2121:2316) = min(I(i:i+ave,2121:2316));
%     fprintf(repmat('\b',1,num));
%     percentage = 100*(i-100)/(2385-ave-100);
%     msg = sprintf('%0.2f%% finished',percentage);
%     num = numel(msg);
%     fprintf('%0.2f%% finished',percentage)
% end
% I = Iverti;

% fprintf('\nExtracting minima...')
for i = istart:iend
    [value,index(i)] = min(I(i,jstart:jend));
%     if abs(index(i)-index(i-1)) > 15 && i > istart
%         index(i) = index(i-1);
%     end
%     fprintf(repmat('\b',1,num));
%     percentage = 100*(i-istart)/(iend-istart);
%     msg = sprintf('%0.2f%% finished',percentage);
%     num = numel(msg);
%     fprintf('%0.2f%% finished',percentage)
end

% fprintf('\nFitting smooth lines...')
p = polyfit(istart:iend,transpose(index(istart:iend)),2);
 index2(istart:iend) = round(transpose(p(1)*(istart:iend).^2+p(2)*(istart:iend)+...
     p(3)));


% f = fit(transpose(istart:iend),index(istart:iend),'poly2');
% index2(istart:iend) = round(transpose(f.p1*(istart:iend).^2+f.p2*(istart:iend)+f.p3));



% num = 0;
% fprintf('\nReconstructing image...')
for i = 1:sizeI(1)
    for j = 1:sizeI(2)
        if j == index2(i)+jstart-1 && i>istart-1 && i<iend+1
            for d = -2:2
                Irec(i,j+d) = 0;
            end
        end
%         if j == index(i)+jstart-1 && i>istart-1 && i<iend+1
%             Irec(i,j) = 0;
%         end
    end
%     fprintf(repmat('\b',1,num));
%     percentage = 100*i/(sizeI(1));
%     msg = sprintf('%0.2f%% finished',percentage);
%     num = numel(msg);
%     fprintf('%0.2f%% finished',percentage)
end
% fprintf('\n')
% imwrite(uint8(Irec),'scanBG.tif')

        