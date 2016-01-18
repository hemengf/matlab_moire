function [h,bnd] = singlerow_height_int(Labelmb,Labelint,angle_interpolation,row_index);

% integrates angle to height for a single line

h = zeros(1,size(Labelmb,2));
bnd = [];
num = 0;
for j = 1:size(Labelmb,2)
    if Labelmb(row_index,j) == 1
        %hitting on Vboundary
        bnd = [bnd,j];
        continue
    elseif Labelint(row_index,j)>1 ||  Labelmb(row_index,j)>1 
        %hitting on region
        h(j) = h(j-1)+0.5*(angle_interpolation(row_index,j-1)+angle_interpolation(row_index,j));
    elseif Labelint(row_index,j)==0 ||  Labelmb(row_index,j)==0
        %hitting on auxiliary lines
        if j ~= 1 
            h(j) = h(j-1);
        end
    end
%     fprintf(repmat('\b',1,num));
%     percentage = 100*(j-1)/(size(Labelmb,2)-1);
%     msg = sprintf('%0.1f%% finished',percentage);
%     num = numel(msg);
%     fprintf('%0.1f%% finished',percentage)
end
% fprintf('\n')
h = h-h(find(Labelmb(row_index,:) == 1,1,'last')-55);
h((find(Labelmb(row_index,:) == 1,1,'last')-55):end) = 0;
h(1:(find(Labelmb(row_index,:) == 1,1,'first')+55)) = 0;
% figure
% plot(h)


