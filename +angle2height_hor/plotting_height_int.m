function plotting_height_int(h,istart,iend)

% plots height; also a quick fix to the plot

hsurf = surf(h(istart:10:iend,1:10:3264));
% set(hsurf,'LineStyle','none');
camproj('perspective')
pbaspect([3264,iend-istart, 800])
set(hsurf,'MeshStyle','row');
hlight = light;
fprintf('\n')