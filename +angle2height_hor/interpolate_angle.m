function [visual_angle_interpolation,angle_interpolation] = interpolate_angle(Labelint,Labelmb,b,offset);

% interpolates angles from discrete angle contour lines using 1/distance averaging

import angle2height_hor.inclination_assignment
import angle2height_hor.boundaries_assignment
import angle2height_hor.coordinatemap_stripeind

tic
angle_interpolation = zeros(size(Labelmb));
anglemapobj = inclination_assignment(b,offset);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

boundariesmapobj = boundaries_assignment(Labelmb,Labelint);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

coordinatemapobj = coordinatemap_stripeind(Labelmb);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


num = 0;

for i = 1:1:size(Labelmb,1)
    for j = 1:1:size(Labelmb,2)
        region_label = Labelint(i,j);
        mb_label = Labelmb(i,j);
        %in most cases mb_label is stripenum
        if region_label==0 && mb_label>1 
            %the point hits on moire stripes
            angle_interpolation(i,j) = anglemapobj(mb_label);
            continue
        elseif region_label==0 && mb_label<=1
            %the point hits on region-division auxiliary lines or
            %Vboundaries
            continue
        elseif region_label > 1
            %the point hits in the interpolate region
            bounding_stripeind = boundariesmapobj(region_label);
            angle_contri = 0;
            normalization = 0;
            theta = zeros(1,numel(bounding_stripeind));
            d = zeros(1,numel(bounding_stripeind));
            for k = 1:numel(bounding_stripeind)
                coordinate_mat = coordinatemapobj(bounding_stripeind(k));
                [~,d(k)] = dsearchn(coordinate_mat,[i,j]);
                theta(k) = anglemapobj(bounding_stripeind(k));
                angle_contri = theta(k)/d(k) + angle_contri;
                normalization = normalization + 1/d(k);
            end
            angle_interpolation(i,j) = angle_contri/normalization;
%             test(1+(i-1)/1,1+(j-1)/1) = angle_interpolation(i,j);
        end
    end
    fprintf(repmat('\b',1,num));
    percentage = 100.0*(i-1)/(size(Labelmb,1)-1);
    msg = sprintf('%0.1f%% finished',percentage);
    num = numel(msg);
    fprintf('%0.1f%% finished',percentage)
end
visual_angle_interpolation = 255*(angle_interpolation-min(min(angle_interpolation)))/(max(max(angle_interpolation))-min(min(angle_interpolation)));
fprintf('\n')
imwrite(uint8(visual_angle_interpolation),'./+angle2height_hor/visual_angle_interpolation.tif')

toc
