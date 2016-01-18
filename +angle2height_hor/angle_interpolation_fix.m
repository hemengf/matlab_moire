function fix_angle_interpolation = angle_interpolation_fix(angle_interpolation,Labelmb,Labelint,samplegap);

% sets the points on auxiliary lines as high as neighbouring points


import angle2height_hor.plotting_angle_interpolation

fix_angle_interpolation = angle_interpolation;
for i = 1:1:size(Labelmb,1)
    for j = 1:1:size(Labelmb,2)
        region_label = Labelint(i,j);
        mb_label = Labelmb(i,j);
        if region_label==0 && mb_label==0
            %hitting on auxiliary lines
            fix_angle_interpolation(i,j) = fix_angle_interpolation(i,j-1);
        end
    end
end

 plotting_angle_interpolation(fix_angle_interpolation,samplegap);