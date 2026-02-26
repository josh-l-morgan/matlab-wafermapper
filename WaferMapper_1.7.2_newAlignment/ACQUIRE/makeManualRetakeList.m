%% Make manual retake list

%%Enter list
manualRetakeList = ...
    [77:200];
%manualRetakeList = sort(manualRetakeList,'ascend')
TPN = GetMyDir;


save([TPN 'manualRetakeList.mat'],'manualRetakeList');