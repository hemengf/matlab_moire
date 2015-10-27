function [Gmag,Gdir,Iave,track_theta,marker] = directional_average(I,patchsize,ave);


tic
I = double(I);
sizeI = size(I);
H = fspecial('gaussian',[5,5],5);
I = imfilter(I,H);
Iave = I;
num = 0;
num2 = 0;
track_theta =0* I;
ave_fix = ave*ones(size(I));
marker = 255*ones(sizeI);


[Gmag,Gdir] = imgradient(uint8(I));
Gdir(Gdir<0) = 180+Gdir(Gdir<0);
% to make all angles positive and to merge equivalent ones.

for i = 1+patchsize:(sizeI(1)-patchsize)
    for j = 1+patchsize:(sizeI(2)-patchsize)
        
%         patch = I(i-patchsize:i+patchsize,j-patchsize:j+patchsize);
%         Gmag_patch = Gmag(i-patchsize:i+patchsize,j-patchsize:j+patchsize);
%         Gdir_patch = Gdir(i-patchsize:i+patchsize,j-patchsize:j+patchsize);
%         
% 
%         Gmag_patch = uint8(Gmag_patch); 
%         %make elements integers; uint8 makes integers, and cuts between0 and 255
%         Gmag_patch = im2bw(Gmag_patch,0.05);
%         %gives logical 0 and 1, need double 0 and 1 for numerical operation
%         Gmag_patch = double(Gmag_patch);
%         %pick out largest elements in magnitude map set by the binary threshold 
%         Gdir_patch = Gmag_patch.*Gdir_patch;
% 
%         h = histogram(Gdir_patch(Gdir_patch~=0),(0:180));
%         histovalues = h.Values;
%         exceptions = [1,46,91,136];
%         histovalues(exceptions) = h.Values(exceptions+1);
%         f = sgolayfilt(histovalues,3,71);
        f = patch_angle_histo(j,i,patchsize,I,Gmag,Gdir);

%         if abs(max(f)/min(f)) < 2
%             fprintf('(%d,%d),%0.2f,%0.2f\n',i,j,max(f),min(f))
%         end
        [value,index] = max(f);
        theta = index;
        
        

        patchsize_fix = patchsize;
        
        while max(max(f(1:90)),max(f(91:180)))/min(max(f(1:90)),max(f(91:180))) < 1.5
            patchsize_fix = patchsize_fix-4;
            ave_fix(i,j) = ave_fix(i,j)-2;
            if patchsize_fix <= 3 || ave_fix(i,j)<=1
                marker(i,j) = 0;
                break
            end
            f = patch_angle_histo(j,i,patchsize_fix,I,Gmag,Gdir);
            [value,index] = max(f);
%             fprintf('(%d,%d)',i,j)
%             fprintf('patchsize: %d ',patchsize_fix)
%             fprintf('ave: %d \n',ave_fix(i,j))
        end
        

            

       
%         plot(f)
%         titlestring = sprintf('%d,%d',i,j);
%         title(titlestring)
%         drawnow
        

%         [peakvalue,peaklocs] = findpeaks(f,'MinPeakProminence',5);
%         if isempty(peaklocs)
%             theta = -1; 
%         end
%         weighed_average = peakvalue*peaklocs'/sum(peakvalue);
%         theta = weighed_average;
        track_theta(i,j) = theta;
        
%         fprintf(repmat('\b',1,num));
%         msg = sprintf('(%d,%d)\n',i,j);
%         num = numel(msg);
%         fprintf('(%d,%d)\n',i,j)
    
    end
    fprintf(repmat('\b',1,num));
    percentage = 100*(i-patchsize)/(sizeI(1)-2*patchsize);
    msg = sprintf('%0.0f%% finished; inclination: %0.1f, row %d',percentage,theta,i);
    num = numel(msg);
    fprintf('%0.0f%% finished; inclination: %0.1f, row %d',percentage,theta,i)
end
fprintf('\n')


num = 0;
for i = ave+1:sizeI(1)-ave
    for j = ave+1:sizeI(2)-ave
        patch = I(i-ave_fix(i,j):i+ave_fix(i,j),j-ave_fix(i,j):j+ave_fix(i,j));
        Gmag_patch = Gmag(i-ave_fix(i,j):i+ave_fix(i,j),j-ave_fix(i,j):j+ave_fix(i,j));
        Gdir_patch = Gdir(i-ave_fix(i,j):i+ave_fix(i,j),j-ave_fix(i,j):j+ave_fix(i,j));

        rotated_patch = imrotate(patch,-track_theta(i,j));
        
        sizer = size(rotated_patch);
        Iave(i,j) = mean(rotated_patch(((sizer(1)+1)/2-ave_fix(i,j)):((sizer(1)+1)/2+ave_fix(i,j)),(sizer(2)+1)/2));
    end
    fprintf(repmat('\b',1,num));
    percentage = 100*(i-ave)/(sizeI(1)-2*ave);
    msg = sprintf('%0.0f%% finished; inclination: %0.1f, row %d',percentage,theta,i);
    num = numel(msg);
    fprintf('%0.0f%% finished; inclination: %0.1f, row %d',percentage,theta,i)
end

imwrite(uint8(track_theta),'track_theta.tif');

fprintf('\n')
Iave = uint8(Iave);
imwrite(Iave,'Iave.tif')
imwrite(marker,'marker.tif')
winopen('Iave.tif')        
winopen('track_theta.tif')
winopen('marker.tif')
