function coordinatemapobj = coordinatemap_stripeind(Labelmb);

% a map from stripe index to a list of points (in the form of their coordinates) for that index

coordinatemapobj = containers.Map('KeyType','double','ValueType','any');
stripe_list = unique(Labelmb(Labelmb>1))';
totnum_stripes = numel(stripe_list);
num = 0;
for k = stripe_list
    [x,y] = find(Labelmb == k);
    coordinatemapobj(k) = [x,y];
    fprintf(repmat('\b',1,num))
    percentage = 100*find(stripe_list == k)/totnum_stripes;
    msg = sprintf('%0.0f%% of coordinates bind to stripe indices',percentage);
    num = numel(msg);
    fprintf('%0.0f%% of coordinates bind to stripe indices',percentage)
end
fprintf('\n')