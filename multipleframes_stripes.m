function [displacementBG,displacementV,quotient1,quotient2,error1,error2] = multipleframes_stripes(framestartBG, frameendBG,framestartV,frameendV,spacingBG,spacingV);
%function called: singleframe_stripes(I); synchronization_BG_V(framestartBG,frameendBG,framestartV,frameendV,displacementBG,displacementV);

%iterate in a folder of frames, find frames of stripes of 
%even space using singleframe_stripes(I), and
%superimpose them to form a denser grid
%2015_9_22

%% background stripes
filestructure =  dir('C:\users\Nagel lab\Desktop\Mengfei_2015_9_22\scan_40_40_c_BG');
I = imread(['C:\Users\Nagel Lab\Desktop\Mengfei_2015_9_22\scan_40_40_c_BG','\',filestructure(3).name]);
I = double(I);
sizeI = size(I);
Ireconstruction = 255*ones(sizeI);
Ireconstruction_smooth = 255*ones(sizeI);
realmeasureBG = zeros(frameendBG-framestartBG+1,14);
n = 0;
k = [];
errorarray = [];%measures error of being integer times of spacing
% displacementarray = [];
stripes_history = [];
fprintf('\nExtracting peaks for BG...\n')
qstartBG = framestartBG;
for q = framestartBG : frameendBG 
    % for loop compile first before execution. Therefore it won't work to
    % insert disp or fprintf inside the problematic iteration to debug. 
    fprintf(repmat('\b',1,n));
    msg = sprintf('    Processing BG frame %0.0f ...',q);
    n = numel(msg);
    fprintf('    Processing BG frame %0.0f ...',q)
    
    I = imread(['C:\Users\Nagel Lab\Desktop\Mengfei_2015_9_22\scan_40_40_c_BG','\',filestructure(q+2).name]);
    [Irec,realmeasureBG(q-framestartBG+1,:),smoothrec,more_stripes_than_usual] = singleframe_stripes(I,stripes_history,600,554,1047,15,15);
    if more_stripes_than_usual == 1 && isempty(stripes_history)
        qstartBG = q+1;
        continue
        %when the starting frame has one more stripe, it's gonna cause
        %inconsistency in the function singleframe_stripes();so ditch ones that
        %include one more stripe in the beginning frames.
    end
    stripes_history = [stripes_history,more_stripes_than_usual];
    displacementBG(q-qstartBG+1) = mean(realmeasureBG(q-framestartBG+1,:)-realmeasureBG(qstartBG-framestartBG+1,:));
    if displacementBG(q-qstartBG+1) < 0
        displacementBG(q-qstartBG+1) = 0;
    end %to prevent inconsistency created by small shaking at the beginning where displacement could be 0. when it starts to move, everything should be ok.
    error1(q-qstartBG+1) = mod(displacementBG(q-qstartBG+1),spacingBG);
    quotient1(q-qstartBG+1) =  (displacementBG(q-qstartBG+1)-error1(q-qstartBG+1))/spacingBG; 
    error2(q-qstartBG+1) = mod(-displacementBG(q-qstartBG+1),spacingBG);
    quotient2(q-qstartBG+1) =  (displacementBG(q-qstartBG+1)+error2(q-qstartBG+1))/spacingBG; 
    
%             %written on 2015/9/22, not perfect for finding evenly spaced
%             %stripes    
%     if min(error1(q),error2(q))<0.8
%          % absolute value in case mean position falls behind the initial
%          %mean position
%          if (length(k)<1) || (length(k)>=1 && q-k(end)>1)
%            % in if clause, everything must be well defined. Ill definition 
%            % is NOT treated as logical 0 
%             k = [k,q];
%             Ireconstruction = min(Irec,Ireconstruction);
%             %or:
%             %Ireconstruction = min(smoothrec,Ireconstruction);
%             errorarray = [errorarray,min(error1(q),error2(q))];
%             displacementarray = [displacementarray,displacement(q)];
%             % (q,:)-(framestart,:) if going right; (framestart,:)-(q,:) if
%             % going left
%         end


    if displacementBG(end) >= 34
        % need to measure mask spacing first
        %this value should be a little bigger than the spacing to make sure
        %the last stripe could come in.
        qendBG = q;
        fprintf('\n    %d BG frames have been analysed', qendBG-framestartBG+1)
        fprintf('\n    the first %d BG frames ditched', qstartBG-framestartBG)
        break
    end
end


%modified on 2015/9/23
%effectively search around each perfect position and find the nearest one;
%use error1 and error2 to represent remainder to the previous perfect
%position and to the next perfect position respectively.
fprintf('\n    Superimposing evenly spaced frames...\n')
n=0;
for q = qstartBG+1:qendBG
    if quotient1(q-qstartBG+1) > quotient1(q-qstartBG)
        %when quotient changes its value, it signifies the crossing of a
        %perfect position.
        if error1(q-qstartBG+1) < error2(q-qstartBG)
            %compare the two stripe position before and next to a perfect
            %position
            I = imread(['C:\Users\Nagel Lab\Desktop\Mengfei_2015_9_22\scan_40_40_c_BG','\',filestructure(q+2).name]);
            [Irec,realmeasureBG(q-framestartBG+1,:),smoothrec,more_stripes_than_usual]...
                = singleframe_stripes(I,stripes_history,600,554,1047,15,15);
            Ireconstruction = min(Irec,Ireconstruction);
            Ireconstruction_smooth = min(smoothrec,Ireconstruction_smooth);
            k = [k,q];
            errorarray = [errorarray,error1(q-qstartBG+1)];
            %positive error means going beyond the perfect position
        else
            I = imread(['C:\Users\Nagel Lab\Desktop\Mengfei_2015_9_22\scan_40_40_c_BG','\',filestructure(q+1).name]);
            [Irec,realmeasureBG(q-framestartBG+1,:),smoothrec,more_stripes_than_usual]...
                = singleframe_stripes(I,stripes_history,600,554,1047,15,15);
            Ireconstruction = min(Irec,Ireconstruction);
            Ireconstruction_smooth = min(smoothrec,Ireconstruction_smooth);
            k = [k,q-1];
            errorarray = [errorarray,-error2(q-qstartBG)];
            %negative error means not reaching the perfect position
        end
    end
    fprintf(repmat('\b',1,n));
    msg = sprintf('    %0.0f%% finished...',100*(q-qstartBG)/(qendBG-qstartBG));
    n = numel(msg);
    fprintf('    %0.0f%% finished...',100*(q-qstartBG)/(qendBG-qstartBG))
end


%             %written on 2015/9/22, not perfect for finding evenly spaced
%             %stripes: some of the errors go to 0.7, and sometimes miss stripes 
%             or find stripes belonging to the same quotient

%     if mean(realmeasure(q,:)-realmeasure(framestart,:))<0 && ...
%             mean(realmeasure(q,:)-realmeasure(framestart,:))>-5
%         %sign issue here as well
%         fprintf('\nFinished! %0.0f frames were processed.', q-framestart+1)
%         break
%     end
% end

imwrite(uint8(Ireconstruction),'scan_40_40_c_BG_multipleframes.tif');
imwrite(uint8(Ireconstruction_smooth),'scan_40_40_c_BG_multipleframes_smooth.tif');
fprintf('\n    Superimposed frames: ')
fprintf('%d ',k)
fprintf('\n    Errors: ')
fprintf('%0.3f ',errorarray)% iterate thru elements of the array


%% synchronize BG movie and V movie
%first step: find displacementV
%second step: calculate offset between displacementBG and displacementV
fprintf('\n\nSynchronizing BG and V movies...\n')
filestructure =  dir('C:\users\Nagel lab\Desktop\Mengfei_2015_9_22\scan_40_40_c_V');
stripes_history = [];
qstartV = framestartV;
n=0;
for q = framestartV:frameendV
    fprintf(repmat('\b',1,n));
    msg = sprintf('    Processing V frame %d ...',q);
    n = numel(msg);
    fprintf('    Processing V frame %d ...',q)
    
    I = imread(['C:\Users\Nagel Lab\Desktop\Mengfei_2015_9_22\scan_40_40_c_V','\',filestructure(q+2).name]);
    [Irec,realmeasureV(q-framestartV+1,:),smoothrec,more_stripes_than_usual]...
        = singleframe_stripes(I,stripes_history,600,537,1051,18,15);
    if more_stripes_than_usual == 1 && isempty(stripes_history)
        qstartV = q+1;
        continue
        %when the starting frame has one more stripe, it's gonna cause
        %inconsistency in the function singleframe_stripes();so ditch ones that
        %include one more stripe in the beginning frames.
    end
    stripes_history = [stripes_history,more_stripes_than_usual];
    displacementV(q-qstartV+1) = mean(realmeasureV(q-framestartV+1,:)-realmeasureV(qstartV-framestartV+1,:));
    if displacementV(q-qstartV+1) < 0
        displacementV(q-qstartV+1) = 0;
    end %to prevent inconsistency created by small shaking at the beginning 
    %where displacement could be 0. when it starts to move, everything should be ok.
    if displacementV(end) >= 29 % need to measure mask spacing first
        qendV= q;
        fprintf('\n    %d frames have been analysed', qendV-framestartV+1)
        fprintf('\n    the first %d frames ditched', qstartV-framestartV)
        break
    end
end
% displacementBG = 0;
% error1 =0;
% error2 = 0;
% quotient1 = 0;
% quotient2 = 0; %useful when only this part is tested.
figure;plot(qstartV:qendV, displacementV, qstartBG:qendBG, displacementBG)

[offset,displacementBG_shift, displacementV_shift]...
    = synchronization_BG_V(framestartBG,frameendBG,framestartV,frameendV,displacementBG,displacementV);
figure;plot(1:length(displacementBG_shift),displacementBG_shift,1:length(displacementBG_shift),displacementV_shift)
fprintf('\n    Calibrated BG offset (+ BG shifted left; - V shifted left): ')
fprintf('%d',offset)
    

%% V stripes

fprintf('\n\nExtracting peaks for V...\n')
IreconstructionV = 255*ones(sizeI);
IreconstructionV_smooth = 255*ones(sizeI);
filestructure =  dir('C:\users\Nagel lab\Desktop\Mengfei_2015_9_22\scan_40_40_c_V');
I = imread(['C:\Users\Nagel Lab\Desktop\Mengfei_2015_9_22\scan_40_40_c_V','\',filestructure(3).name]);
I = double(I);
n = 0;
realoffset = offset+qstartBG-qstartV;
for q = k-realoffset
    I = imread(['C:\Users\Nagel Lab\Desktop\Mengfei_2015_9_22\scan_40_40_c_V','\',filestructure(q+2).name]);
    [Irec,realmeasureV(q-framestartV+1,:),smoothrec,more_stripes_than_usual]...
        = singleframe_stripes(I,stripes_history,600,537,1051,18,15);
    IreconstructionV = min(Irec,IreconstructionV);
    IreconstructionV_smooth = min(smoothrec,IreconstructionV_smooth);
    fprintf(repmat('\b',1,n));
    msg = sprintf('    Superimposing V frame %d ...',q);
    n = numel(msg);
    fprintf('    Superimposing V frame %d ...',q)
end
fprintf('\nFinished!\n')
% IreconstructionV = imfilter(IreconstructionV,H);
imwrite(uint8(IreconstructionV),'scan_40_40_c_V_multipleframes.tif');
imwrite(uint8(IreconstructionV_smooth),'scan_40_40_c_V_multipleframes_smooth.tif');




    

    
    
    
