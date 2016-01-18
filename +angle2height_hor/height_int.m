function h = height_int(istart,iend,Labelmb,Labelint,angle_interpolation);

% integrate angle_interpolation to height

import angle2height_hor.singlerow_height_int
import angle2height_hor.plotting_height_int

h = zeros(size(Labelmb));
num = 0;
for i = istart:iend
    [hrow,~] = singlerow_height_int(Labelmb,Labelint,angle_interpolation,i);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     h(i,bnd(1)+100:bnd(end)) = h_curve; 
    h(i,:) = hrow;
    fprintf(repmat('\b',1,num));
    percentage = 100*(i-istart)/(iend-istart);
    msg = sprintf('%0.1f%% finished',percentage);
    num = numel(msg);
    fprintf('%0.1f%% finished',percentage)
end

plotting_height_int(h,istart,iend)


% hsurf = surf(h(istart:10:iend,1:10:3264));
% % set(hsurf,'LineStyle','none');
% camproj('perspective')
% pbaspect([3264,iend-istart, 800])
% set(hsurf,'MeshStyle','row');
% hlight = light;
fprintf('\n')