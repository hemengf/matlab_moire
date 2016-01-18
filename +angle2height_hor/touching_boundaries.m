function [bounding_stripeind,L_oneregion,L_dilated,boundary_stripes] = touching_boundaries(Labelint,Labelmb,region_label);

% listing boundary line indices(also gray scale in Labelmb in this case)for a given region;


% Labelint = imread('Labelint.tif');
% Labelint = double(Labelint);
% Labelmb = imread('Labelmb.tif');
% Labelmb = double(Labelmb);
%make double. uint8 cause problems when adding or subtracting(always>=0).



i = region_label;
L_oneregion = zeros(size(Labelint));
% L_oneregion = Labelint;


% L_oneregion(L_oneregion~=i)=0;
L_oneregion(Labelint==i)=255;


% imwrite(uint8(L_oneregion),'L_oneregion.tif')
se = strel('disk',1);
L_dilated = imdilate(L_oneregion,se);

% imwrite(uint8(L_dilated),'L_dilated.tif')
boundary_stripes = abs(L_dilated-L_oneregion);
% imwrite(uint8(boundary_stripes),'boundary_stripes.tif')


bounding_stripeind = unique(Labelmb(boundary_stripes==255));
bounding_stripeind = bounding_stripeind(bounding_stripeind>0);
bounding_stripeind(bounding_stripeind==1)=[];

