%% Make manual retake list

%%Enter list
sections = ...
    [ 1:8 15 27 32 34 52 54 56:60 75 97 :200];

tiles{53} = [4 4];
tiles{9} = [1 4];


tiles{max(sections)+1} = [];

manualRetakeList.sections = sections;
manualRetakeList.tiles = tiles;

TPN = GetMyDir;


save([TPN 'manualRetakeList.mat'],'manualRetakeList');