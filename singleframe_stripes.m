function [Irec,realmeasure,smoothrec,more_stripes_than_usual] ...
    = singleframe_stripes(I,stripes_history,ycount,xcountstart,xcountend,num_of_stripes,peakgap);
%function called:  smoothen_multipleframes_stripes(Irec_for_smoothening)


%extract grid peaks in a single frame, and use
%smoothen_multipleframes_stripes(I) to smoothen lines
%2015/9/22

%more_stripes_than_usual (0 or 1) shows if there are more than 15 stripes for
%example in the counting area; it is stored as a vector in the function
%that calls this function as stripes_history to know how many stripes in
%previous calls.
%2015/9/23

% I = imread('C:\users\Nagel lab\Desktop\Mengfei_2015_9_22\scan_40_40_c_BG\scan_40_40_c_BG0000.tif');
% I = imread('C:\users\Nagel lab\Desktop\20_50_c.tif');
I = double(I);
sizeI = size(I);
H = fspecial('gaussian',[15,15],4);
I = imfilter(I, H);
% imwrite(uint8(I),'blurred_fat.tif')

Irec1 = 255*ones(sizeI);
Irec = 255*ones(sizeI);
Irec_for_smoothening = 255*ones(sizeI);

for i  = 1:sizeI(1)
    [peaks, locs] = findpeaks(-I(i,:),'MinPeakDistance',15);
    for d = 0:1
        Irec1(i,locs+d) = 0; %locs+d may go out of matrix dimension boundary
        Irec_for_smoothening(i,1:sizeI(2)) =  Irec1(i,1:sizeI(2)); % thus need this step
    end
    for d = 0:2
        Irec1(i,locs+d) = 0; %locs+d may go out of matrix dimension boundary
        Irec(i,1:sizeI(2)) =  Irec1(i,1:sizeI(2)); % thus need this step
    end
end

smoothrec = smoothen_multipleframes_stripes(Irec_for_smoothening);

%modified on 2015/9/22
%e.g. if there are 15 stripes (measure_positions), only take into acount
%the last 14 of them (realmeasure) to avoid the issue of the first stripe
%going out of the boundary
[peaks,measure_positions] = findpeaks(-I(ycount,xcountstart:xcountend),'MinPeakDistance',peakgap);
if length(measure_positions) == num_of_stripes
    more_stripes_than_usual = 0;
    if isempty(find(stripes_history,1))
        %there hasn't been one more stripe in this area in previous
        %calls
        realmeasure = measure_positions(1:end-1);
    else
        %number of stripes in this area has increased but decreased back to
        %starting number
        realmeasure = measure_positions(2:end);
    end
else
    realmeasure = measure_positions(2:end-1);
    more_stripes_than_usual = 1;
end % only work for going to the right


% imwrite(uint8(Irec),'scan_40_40_c_BG_0000.tif')
% imwrite(uint8(smoothrec),'smoothscan_40_40_c_BG_0000.tif')


