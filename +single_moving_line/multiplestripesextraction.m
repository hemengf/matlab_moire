function index = multiplestripesextraction(framestart, frameend, xcenterstart, xcenterend);
filestructure =  dir('C:\Users\Nagel Lab\Desktop\Mengfei_2015_9_8\scanV');
I = imread(['C:\Users\Nagel Lab\Desktop\Mengfei_2015_9_8\scanV','\',filestructure(3).name]);
I = double(I);
sizeI = size(I);
Irec = 255*ones(sizeI);
n = 0;
index = zeros(sizeI(1),frameend-framestart);
radius = 2450.6/2;
xcircle = 1626;
ycircle = 1129.36;

for q = framestart : frameend
    %%preparing 4 arguments of the function singlestripeextraction(I, istart, iend, jstart, jend)
    I = imread(['C:\Users\Nagel Lab\Desktop\Mengfei_2015_9_8\scanV','\',filestructure(q+2).name]);
    xcenter = (q-framestart)*(xcenterend-xcenterstart)/(frameend-framestart)+xcenterstart;
    istart = 1;
    iend = sizeI(1);
    jstart = round(xcenter)-15;
    jend = round(xcenter)+15;
    
    while (jstart-xcircle)^2+(istart-ycircle)^2 > radius^2 ...
            || (jend-xcircle)^2+(istart-ycircle)^2 > radius^2
        istart = istart+1;
        if istart > sizeI(1)-1
            break
        end
    end
    
    while (jstart-xcircle)^2+(iend-ycircle)^2 > radius^2 ...
            || (jend-xcircle)^2+(iend-ycircle)^2 > radius^2
        iend = iend-1;
        if iend < 1
            break
        end
    end
    
    if istart == sizeI(1) || iend == 1
        continue
    end
        
    %%
    [index,Ireconstruction] = singlestripeextraction(I, istart, iend, jstart, jend);
    index(:,q) = index;
    Irec = min(Irec,Ireconstruction);

    fprintf(repmat('\b',1,n));
    percentage = 100*(q-framestart)/(frameend-framestart);
    msg = sprintf('%0.2f%% finished',percentage);
    n = numel(msg);
    fprintf('%0.2f%% finished',percentage)
end
fprintf('\n')
imwrite(uint8(Irec),'scanV2_allstripes.tif')
    