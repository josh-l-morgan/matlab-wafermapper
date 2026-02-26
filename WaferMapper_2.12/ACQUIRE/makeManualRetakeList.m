%% Make manual retake list

%%Enter list
%manualRetakeList = [1:19;
manualRetakeList = ([]);% do 5 6 7 9 16 17 20 21 22 28 
%119 122      8 120 121 123:125 127:157 
% 76 77 81 82 159]; 
% 75 92 106
%ixQwaf002 thick - 2 26 27 48 59 64 99 109 116 117 118 
%78 117 129 138
%150 138 133 112 106 91 76 57 56 36 
%162 157 139
%73 74 104 105 106 131 132 133 134 135 151 152 154 155 
%52 98 112 133 149 158 182 
%manualRetakeList = sort(manualRetakeList,'ascend')
TPN = GetMyDir;


save([TPN 'manualRetakeList.mat'],'manualRetakeList');