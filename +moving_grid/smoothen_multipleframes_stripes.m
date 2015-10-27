function smoothrec = smoothen_multipleframes_stripes(I);

% numbers the lines and smoothen them
%misname for historical reasons; actually could be used to smoothen stripes regardless
%single or superimposed mulitiple frames
%2015/9/22



% I = imread('multipleframes_V.tif');
I = double(I);
sizeI = size(I);
smoothrec = 255*ones(sizeI);

for j = 1:sizeI(2)
    for i = 1:sizeI(1)
        if (j-819)^2+(i-614)^2 <= (1083/2)^2
            if I(i,j) == 0
                stripes = j;
%                  smoothrec(i,j) = 0;
                for k = i+1:sizeI(1)
                    % if a black point is found on the edge, start to
                    % mark black points below it
                    for d = -1:1
                        if I(k,stripes(end)+d) == 0
                            stripes = [stripes,stripes(end)+d];
                            break
                        elseif d == 1
                            stripes = [stripes,stripes(end)];
                        end
                    end
                    if (stripes(end)-819)^2+(k-614)^2 > (1090/2)^2 ...
                        || k == sizeI(1)
                        %the tail of the stripe goes out of the circle; the
                        %circle here should be a little bigger in case in
                        %the beginning the stripe sways out of the circle
                        %defined here
                        %warning('off','all')
                        
                        %start to smoothen
                        p = polyfit(i:k,stripes,2);
                        smoothstripes(i:k) = round(p(1)*(i:k).^2+p(2)*(i:k)+p(3));
                        for q = i:k
                            for d = 0:2
                                smoothrec(q,smoothstripes(q)+d) = 0;
                            end
                        end
                        break
                    end
                end
                break  
                % search only on the edge of the circle for black points
            else
                break
                % search only on the edge of the circle for black points
            end
        end
    end
end

% imwrite(uint8(smoothrec),'smoothrec_V.tif');
        