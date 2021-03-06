function f = patch_angle_histo(patchcenter_x, patchcenter_y,patchsize,I,Gmag,Gdir);
%function called:

% to make histogram of stripe directions of a patch for I given Gmag, Gdir
% of I;
% 2015_10_23

patch = I(patchcenter_y-patchsize:patchcenter_y+patchsize,patchcenter_x-patchsize:patchcenter_x+patchsize);

Gmag_patch = Gmag(patchcenter_y-patchsize:patchcenter_y+patchsize,patchcenter_x-patchsize:patchcenter_x+patchsize);
Gdir_patch = Gdir(patchcenter_y-patchsize:patchcenter_y+patchsize,patchcenter_x-patchsize:patchcenter_x+patchsize);


Gmag_patch = uint8(Gmag_patch); 
%make elements integers; uint8 makes integers, and cuts between0 and 255
Gmag_patch = im2bw(Gmag_patch,0.05);
%gives logical 0 and 1, need double 0 and 1 for numerical operation
Gmag_patch = double(Gmag_patch);

Gdir_patch = Gmag_patch.*Gdir_patch;
%pick out largest elements in magnitude map set by the binary threshold 

h = histogram(Gdir_patch(Gdir_patch~=0),(0:180));
histovalues = h.Values;
exceptions = [1,46,91,136];
%somehow the algorithm of imgradient gives most directions at these
%angles (n*45 degrees)
histovalues(exceptions) = h.Values(exceptions+1);
f = sgolayfilt(histovalues,3,71);