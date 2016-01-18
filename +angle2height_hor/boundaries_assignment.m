function [boundariesmapobj,totnum_regions] = boundaries_assignment(Labelmb,Labelint);

%gives a map from all region numbers to all boundary stripe indices 

import angle2height_hor.touching_boundaries

boundariesmapobj = containers.Map('KeyType','double','ValueType','any');
region_list = unique(Labelint(Labelint>1))';
totnum_regions = numel(region_list);
num = 0;
for k = region_list
    [bounding_stripeind,~,~,~] = touching_boundaries(Labelint,Labelmb,k);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    boundariesmapobj(k) = bounding_stripeind;
    fprintf(repmat('\b',1,num))
    percentage = 100*find(region_list == k)/totnum_regions;
    msg = sprintf('%0.0f%% of regions mapped to boundary indices',percentage);
    num = numel(msg);
    fprintf('%0.0f%% of regions mapped to boundary indices',percentage)
end
fprintf('\n')