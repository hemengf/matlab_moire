function run(istart,iend,samplegap,b,offset)

% starts the program

% istart = 200;
% iend = 2000;
% samplegap = 10;
% b = 0.015;
% offset = -0.01;

import angle2height_hor.interpolate_angle
import angle2height_hor.angle_interpolation_fix
import angle2height_hor.height_int


Labelmb = imread('./+angle2height_hor/Labelmb.tif');
Labelint = imread('./+angle2height_hor/Labelint.tif');
assignin('base','Labelmb',Labelmb)
assignin('base','Labelint',Labelint)
% save results to workspace to be used for adjusting plots later

fprintf('\ninterpolating angles...\n')
[visual_angle_interpolation,angle_interpolation] = interpolate_angle(Labelint,Labelmb,b,offset);
winopen('visual_angle_interpolation.tif')
angle_interpolation = angle_interpolation_fix(angle_interpolation,Labelmb,Labelint,samplegap);
assignin('base','angle_interpolation',angle_interpolation)

fprintf('\nintegrating heights...\n')
h = height_int(istart,iend,Labelmb,Labelint,angle_interpolation);
assignin('base','h',h)
fprintf('\nfinished!\n')