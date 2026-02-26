function[] = wmBacklash(sm);

if 0 % temporarily negated
%attempt to get zeiss api comm object from GuiGlobalsStruct if none is provided
if ~exist('sm')
    global GuiGlobalsStruct;
    sm = GuiGlobalsStruct.MyCZEMAPIClass;
end

backlashOffset = 100/1000000; %in microns to meters (10 is too slow)

tic

%% Get stage information prior to stage INI
%disp('Getting stage position');
stage_x = sm.Get_ReturnTypeSingle('AP_STAGE_AT_X');
stage_y = sm.Get_ReturnTypeSingle('AP_STAGE_AT_Y');
stage_z = GuiGlobalsStruct.MyCZEMAPIClass.Get_ReturnTypeSingle('AP_STAGE_AT_Z');
stage_t = GuiGlobalsStruct.MyCZEMAPIClass.Get_ReturnTypeSingle('AP_STAGE_AT_T');
stage_r = GuiGlobalsStruct.MyCZEMAPIClass.Get_ReturnTypeSingle('AP_STAGE_AT_R');
stage_m = GuiGlobalsStruct.MyCZEMAPIClass.Get_ReturnTypeSingle('AP_STAGE_AT_M');


sm.MoveStage(stage_x + backlashOffset ,stage_y + backlashOffset,stage_z,stage_t,stage_r,stage_m)

while (strcmp(lower(GuiGlobalsStruct.MyCZEMAPIClass.Get_ReturnTypeString('DP_STAGE_IS')),'busy'))
    pause(.01)
end

sm.MoveStage(stage_x ,stage_y ,stage_z,stage_t,stage_r,stage_m);
GuiGlobalsStruct.MyCZEMAPIClass.Get_ReturnTypeString('DP_STAGE_IS')
while (strcmp(lower(GuiGlobalsStruct.MyCZEMAPIClass.Get_ReturnTypeString('DP_STAGE_IS')),'busy'))
    pause(.01)
end
%%Check for change in position
for s = 1:10
    
    new_stage_x = sm.Get_ReturnTypeSingle('AP_STAGE_AT_X');
    new_stage_y = sm.Get_ReturnTypeSingle('AP_STAGE_AT_Y');
    
    if (new_stage_x ~= stage_x) | (new_stage_y ~= stage_y)
        'missed first backlash'
        sprintf('missed backlash. Retry number %d. Xdif = %0.6f mm. Ydif = %0.6f mm.',s,1000 *(new_stage_x-stage_x),1000 * (new_stage_y-stage_y))
        
        sm.MoveStage(stage_x ,stage_y ,stage_z,stage_t,stage_r,stage_m);
        while (strcmp(lower(GuiGlobalsStruct.MyCZEMAPIClass.Get_ReturnTypeString('DP_STAGE_IS')),'busy'))
            pause(.01)
        end
        
    end
    
    
end


'Time spent on second stage movement, consider removing'
toc
end %negate backlash
