%% Make manual retake list

%%Enter list
manualRetakeList = ...
[ 1    23    60    66    69    76    78 3     6    76   147];
%manualRetakeList = sort(manualRetakeList,'ascend')
TPN = GetMyDir;


save([TPN 'manualRetakeList.mat'],'manualRetakeList');