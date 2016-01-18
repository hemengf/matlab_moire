function plotting_angle_interpolation(angle_interpolation,samplegap)

% plots angle_interpolation; also a quick fix to the plot

figure
h = surf(angle_interpolation(1:samplegap:end,1:samplegap:end));
pbaspect([3264,2400,800])
camproj('perspective')
set(h,'LineStyle','none');
hlight = light;
