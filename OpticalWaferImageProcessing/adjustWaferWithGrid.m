
SPN = 'Y:\Active\morganLab\DATA\KxS_L_AlbinoLGN\OpticalWaferImages\grid background\'

TPN = 'Y:\Active\morganLab\DATA\KxS_L_AlbinoLGN\OpticalWaferImages\grid_background_adjusted\'




nams = dir([SPN '*.bmp'])
nams = {nams(:).name};

for i = 1:length(nams)
    
   
    I = imread([SPN nams{i}]);
    
    pts = ginput
    
    
    
end









