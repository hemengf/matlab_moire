function stretch(C,peakgap,iave,jave);
%function called: triangular_stripes;

%pay attention to remove imwrite and winopen when using this function
%inside some other loop; otherwise this matlab is going to crash

tic
%% blur and triangulate, for comparison
C = imread('CR.tif');
C = double(C);
Cblur = C;
sizeC  = size(C);
for i = 1+iave:sizeC(1)-iave
    for j = jave+1:sizeC(2)-jave
        Cblur(i,j) = mean(mean(C(i-iave:i+iave,j-jave:j+jave)));
    end
end
Itri = triangular_stripes(Cblur,peakgap);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
imwrite(uint8(Itri),'blur_tri.tif');
winopen('blur_tri.tif');


%% stretch + blur + triangulate,step 1
REC = imresize(C,[3*sizeC(1),sizeC(2)]);
REC = double(REC);
sizeR  = size(REC);
for i = 1+iave:sizeR(1)-iave
    for j = jave+1:sizeR(2)-jave
        REC(i,j) = mean(mean(REC(i-iave:i+iave,j-jave:j+jave)));
    end
end
Itri = triangular_stripes(REC,peakgap);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
imwrite(uint8(Itri),'str_blur_tri.tif');
triREblur = Itri;
winopen('str_blur_tri.tif')
%% step 1 + blur + compress
sizetri  = size(Itri);
for i = 1+iave:sizetri(1)-iave
    for j = jave+1:sizetri(2)-jave
        triREblur(i,j) = mean(mean(Itri(i-iave:i+iave,j-jave:j+jave)));
    end
end

REREC = imresize(uint8(triREblur),[sizeC(1),sizeC(2)]);
imwrite(uint8(REREC),'REREC.tif')
winopen('REREC.tif')
toc