function [Gmag,Gdir,Iave,track_theta,marker] = directional_average(I,patchsize,ave);
%function called: patch_angle_histo

%To average image in the direction of 'stripe stream line'
%2015_10_23

I = double(I);
sizeI = size(I);
H = fspecial('gaussian',[5,5],5);
I = imfilter(I,H);
Iave = I;
num = 0;
track_theta =0* I;
ave_fix = ave*ones(size(I));
marker = 255*ones(sizeI);


[Gmag,Gdir] = imgradient(uint8(I));
Gdir(Gdir<0) = 180+Gdir(Gdir<0);
% to make all angles positive and to merge equivalent ones.

%% to get rotation angle at each point
for i = 1+patchsize:(sizeI(1)-patchsize)
    for j = 1+patchsize:(sizeI(2)-patchsize)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        f = patch_angle_histo(j,i,patchsize,I,Gmag,Gdir);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [value,index] = max(f);
        theta = index;
        patchsize_fix = patchsize;
        while max(max(f(1:90)),max(f(91:180)))/min(max(f(1:90)),max(f(91:180))) < 1.5
            patchsize_fix = patchsize_fix-4;
            ave_fix(i,j) = ave_fix(i,j)-2;
            if patchsize_fix <= 3 || ave_fix(i,j)<=1
                marker(i,j) = 0;
                %'marker' marks (black spots) where the two peaks are still too close in
                %magnitude at the end
                break
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            f = patch_angle_histo(j,i,patchsize_fix,I,Gmag,Gdir);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            [value,index] = max(f);
%             theta = index;
%             fprintf('(%d,%d)',i,j)
%             fprintf('patchsize: %d ',patchsize_fix)
%             fprintf('ave: %d \n',ave_fix(i,j))
        end
%         plot(f)
%         titlestring = sprintf('%d,%d',i,j);
%         title(titlestring)
%         drawnow
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

%% to rotate and average for each point
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
