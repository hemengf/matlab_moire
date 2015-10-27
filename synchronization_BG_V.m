function [offset,displacementBG_shift,displacementV_shift] = synchronization_BG_V(framestartBG,frameendBG,framestartV,frameendV,displacementBG,displacementV);
[valuemaxBG,indexBG] = max(displacementBG);
[valuemaxV,indexV] = max(displacementV);
displacementBG_shift = displacementBG;
normalization = valuemaxBG/valuemaxV;
displacementV_shift = normalization*displacementV;
displacementBG_shift(max(frameendBG-framestartBG+1,frameendV-framestartV+1)) = 0;
displacementV_shift(max(frameendBG-framestartBG+1,frameendV-framestartV+1)) = 0;
%to make sure V_shift and BG_shift are the same dimension

if indexBG >= indexV
    %if BG lags behind, shift it to the left
    for i = 1:length(displacementBG_shift)
        overlap(i) = displacementBG_shift*displacementV_shift';
        displacementBG_shift(1) = [];
        displacementBG_shift = [displacementBG_shift,0];
    end
    [value,index] = max(overlap);
    offset= index-1;
    %positive if BG lags behind
    displacementBG_shift = displacementBG;
    displacementBG_shift(max(frameendBG-framestartBG+1,frameendV-framestartV+1)) = 0;
    %get the original BG_shift before cutting and looping
    displacementBG_shift(1:offset)=[];
    displacementBG_shift = [displacementBG_shift,zeros(1,offset)];
    %shift BG_shift to offset amount 
else
    %otherwise do the samething to V
    for i = 1:length(displacementBG_shift)
        overlap(i) = displacementBG_shift*displacementV_shift';
        displacementV_shift(1) = [];
        displacementV_shift = [displacementV_shift,0];
    end
    [value,index] = max(overlap);
    offset = -index+1;
    %negative if BG leads ahead
    displacementV_shift = displacementV;
    displacementV_shift(max(frameendBG-framestartBG+1,frameendV-framestartV+1)) = 0;
    displacementV_shift(1:-offset)=[];
    displacementV_shift = [displacementV_shift,zeros(1,-offset)];
end
% figure;plot(1:length(displacementBG_shift),displacementBG_shift,1:length(displacementBG_shift),displacementV_shift)