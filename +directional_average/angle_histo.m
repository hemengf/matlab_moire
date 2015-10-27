warning('off','all')
CC2 = imread('crop1.tif');
H = fspecial('gaussian',[5,5],5);
CC2 = imfilter(CC2,H);
[Gmag,Gdir] = imgradient(uint8(CC2));
Gdir(Gdir<0) = 180+Gdir(Gdir<0);
Gmag = uint8(Gmag); 
Gmag = im2bw(Gmag,0.05);
Gmag = double(Gmag);
Gdir = Gmag.*Gdir;
figure;
h = histogram(Gdir(Gdir~=0),(0:180));
histovalues = h.Values;
exceptions = [1,46,91,136];
histovalues(exceptions) = h.Values(exceptions+1);
% f = sgolayfilt(histovalues,3,71);
f = fit((1:180)',histovalues','smoothingspline','SmoothingParam', 0.01);
f = f(1:1:180)';
curvefit = fit((1:180)',f','poly7');
ft = curvefit(1:1:180);
hold on
plot((1:180),f,'b',(1:180),ft,'r',(1:180),histovalues,'k')
findpeaks(ft)
max(f)-min(f)
hold off