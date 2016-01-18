% +ANGLE2HEIGHT_HOR
% version 1.0 30-11-2015
% Files
%   angle_interpolation_fix      - sets the points on auxiliary lines as high as neighbouring points
%   boundaries_assignment        - gives a map from all region numbers to all boundary stripe indices 
%   coordinatemap_stripeind      - a map from stripe index to a list of points (in the form of their coordinates) for that index
%   height_int                   - integrate angle_interpolation to height
%   inclination_assignment       - makes a map between labeled lines and angles
%   interpolate_angle            - interpolates angles from discrete angle contour lines using 1/distance averaging
%   plotting_angle_interpolation - plots angle_interpolation; also a quick fix to the plot
%   plotting_height_int          - plots height; also a quick fix to the plot
%   run_angle_height             - starts programs; should >>run from matlab/
%   singlerow_height_int         - integrates angle to height for a single line
%   touching_boundaries          - listing boundary line indices(also gray scale in Labelmb in this case)for a given region;
