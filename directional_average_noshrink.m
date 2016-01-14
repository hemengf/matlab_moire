function [Gmag,Gdir,Iave,track_theta,marker,Iave_triangulate] = directional_average_noshrink(I,patchsize,ave,ave_tri);
%function called: patch_angle_histo

%43917s(12.2h) in office computer for 1200*1632 in directional_average(T,20,10,35). 
%438s(7.3m) in office computer for 260*193 in directional_average(T,20,10,35).
tic
import directional_average.patch_angle_histo
I = double(I);
sizeI = size(I);
% H = fspecial('gaussian',[5,5],15);
% I = imfilter(I,H);
Iave = I;
Iave_triangulate = I;

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
        f = patch_angle_histo(j,i,patchsize,I,Gmag,Gdir);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        [value,index] = max(f);
        theta = index;
        
        patchsize_fix = patchsize;
        
%         while max(max(f(1:90)),max(f(91:180)))/min(max(f(1:90)),max(f(91:180))) < 1.5
%             patchsize_fix = patchsize_fix-4;
%             ave_fix(i,j) = ave_fix(i,j)-2;
%             if patchsize_fix <= 3 || ave_fix(i,j)<=1
%                 marker(i,j) = 0;
%                 break
%             end
%             f = patch_angle_histo(j,i,patchsize_fix,I,Gmag,Gdir);
%             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             [value,index] = max(f);
%             theta = index;
% %             fprintf('(%d,%d)',i,j)
% %             fprintf('patchsize: %d ',patchsize_fix)
% %             fprintf('ave: %d \n',ave_fix(i,j))
%         end
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
    msg = sprintf('%0.0f%% finished; inclination: %0.1f, row %d',percentage,track_theta(i,j),i);
    num = numel(msg);
    fprintf('%0.0f%% finished; inclination: %0.1f, row %d',percentage,track_theta(i,j),i)
end
fprintf('\n')

num = 0;
for i = 1+ave_tri:sizeI(1)-ave_tri
    for j = 1+ave_tri:sizeI(2)-ave_tri
        Iave_patch = Iave(i-ave_tri:i+ave_tri,j-ave_tri:j+ave_tri);
        Iave_rotated_patch = imrotate(Iave_patch,-track_theta(i,j));
        sizer = size(Iave_rotated_patch);
%         Iave_rpatch_triangulate = triangular_stripes(Iave_rotated_patch,15);
%         %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
%         Iave_triangulate(i,j) = Iave_rpatch_triangulate(round((sizer(1)+1)/2),round((sizer(2)+1)/2));
%         %too slow; not necessary to trangulate the whole patch; just need that
%         %specific row
        [peaks, locspeak] = findpeaks(Iave_rotated_patch(round((sizer(1)+1)/2),:),'MinPeakProminence',2);
        [peaks,locsbottom] = findpeaks(-Iave_rotated_patch(round((sizer(1)+1)/2),:),'MinPeakProminence',2);
        if numel(locspeak)*numel(locsbottom) ~= 0
            Iave_rotated_patch(round((sizer(1)+1)/2),min(locspeak(1),locsbottom(1)):1:max(locspeak(end),locsbottom(end)))...
            = interp1([locspeak,locsbottom],[255*ones(1,length(locspeak)),zeros(1,length(locsbottom))],min(locspeak(1),locsbottom(1)):1:max(locspeak(end),locsbottom(end)));
            Iave_triangulate(i,j) =  Iave_rotated_patch(round((sizer(1)+1)/2),round((sizer(2)+1)/2));
        end
    end
    fprintf(repmat('\b',1,num));
    percentage = 100*(i-ave_tri)/(sizeI(1)-2*ave_tri);
    msg = sprintf('%0.0f%% finished; inclination: %0.1f, row %d',percentage,track_theta(i,j),i);
    num = numel(msg);
    fprintf('%0.0f%% finished; inclination: %0.1f, row %d',percentage,track_theta(i,j),i)

end

imwrite(uint8(track_theta),'track_theta.tif');

fprintf('\n')
Iave = uint8(Iave);
imwrite(Iave,'Iave.tif')
imwrite(marker,'marker.tif')
imwrite(uint8(Iave_triangulate),'Iave_triangulate.tif')
% winopen('Iave.tif')        
% winopen('track_theta.tif')
% winopen('marker.tif')
toc
