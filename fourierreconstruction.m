function Inew = fourierreconstruction()
warning('off','all')
I = imread('C:\users\Nagel lab\Desktop\test.tif');
I = double(I);
sizeI = size(I);
num = 0;
n = pow2(nextpow2(sizeI(2)));
f = (0:n-1)*(1/n);
t = 1:sizeI(2);
phase = cell(1,491);
reconstructed = zeros(1,sizeI(2));
Inew = zeros(sizeI(1),sizeI(2));
for i  =  1 : sizeI(1)
    fouriercomponent = fft(I(i,:),n);
    [value, index] = max(fouriercomponent(10:1000));
%     for j = 10:400
%         if abs(fouriercomponent(j))>value*0.1
%             phase{j-9} = angle(fouriercomponent(j))+2*pi*(j-1)*(t-1)/n;
%         else
%             phase{j-9} = pi/2;
%         end
%         reconstructed = reconstructed + abs(fouriercomponent(j)*cos(phase{j-9}));
%     end
    for j = 20:300
       reconstructed = reconstructed + fouriercomponent(j)*exp(sqrt(-1)*2*pi*(j-1)*(t-1)/n);
    end
    [peaks, locs] = findpeaks(real(reconstructed),'MinPeakDistance',10);
    for k = 1:sizeI(2)
        for d = -3:3
            if ismember(k+d,locs)
            Inew(i,k) = 255;
            end
        end
    end
    %phase = angle(value)+2*pi*(index-1)*(t-1)/n;
%     for k = 1:sizeI(2)
%         if reconstructed(k)>500
%             I(i,k) = 255;
%         else
%             I(i,k) = 0;
%         end
%     end
    fprintf(repmat('\b',1,num));
    percentage = 100*i/sizeI(1);
    msg = sprintf('%0.3f%% finished',percentage);
    num = numel(msg);
    fprintf('%0.3f%% finished',percentage)
end
Inew = uint8(Inew); 
figure
imshow(Inew)
%saveas(gcf,'testrecons.tif')





% t = 1:sizeI(2);
% phase = cell(1,491);
% reconstructed = zeros(1,sizeI(2));
% for j = 10:500
%     if abs(fouriercomponent(j))>value*0.2
%         phase{j-9} = angle(fouriercomponent(j))+2*pi*(j-1)*(t-1)/n;
%     else
%         phase{j-9} = pi/2;
%     end
%     reconstructed = reconstructed + abs(fouriercomponent(j))*cos(phase{j-9});
% end
% plot(t,reconstructed)
% figure
% plot(t,I(500,:))
% 
% a = zeros(1,11)
% for j = 10:20
%     a(j-9) = j*t;
% end
% a