function[focusPosition] = smartTileFocus(focOptions)

%% focus position is returned as XY
%% Retrieve necessary info
global GuiGlobalsStruct;

acFocParam.qualMode = 1;

sm = GuiGlobalsStruct.MyCZEMAPIClass; %To shorten calls to global API variables in this function
sm.Execute('CMD_FREEZE_ZONE');

if ~exist('focOptions','var')
    focOptions.IsDoQualCheck = 0;
    focOptions.QualityThreshold = 0;
end

StartingMagForAF = focOptions.StartingMagForAF;
IsPerformAutoStig = focOptions.IsPerformAutoStig;
StartingMagForAS = focOptions.StartingMagForAS;

% Change to the user-specified stigmation values StartingStigX,
% StartingStigY, instead of the current stigmation values
startWD = GuiGlobalsStruct.MontageParameters.AFStartingWD;
lastWD = GuiGlobalsStruct.MontageParameters.AFLastWD
startStigX = GuiGlobalsStruct.MontageParameters.StartingStigX;
startStigY = GuiGlobalsStruct.MontageParameters.StartingStigY;

%% Karl dist fix ***

GuiGlobalsStruct.MontageParameters.WDResetThreshold = 0.0005;
WDResetThreshold = GuiGlobalsStruct.MontageParameters.WDResetThreshold;AutoWorkingDistance =sm.Get_ReturnTypeSingle('AP_WD');
startWD-lastWD
if (abs(startWD - lastWD) > WDResetThreshold)
    %If the WD has gone far enough from CurrentWorkingDistance
    %(=AFStartingWD),reset it to CurrentWorkingDistance (i.e.
    %AFStartingWD, which is the WD used at the beginning of this
    %calculation)
    sm.Set_PassedTypeSingle('AP_WD', startWD);
else
    GuiGlobalsStruct.MyCZEMAPIClass.Set_PassedTypeSingle('AP_WD',lastWD );
end

GuiGlobalsStruct.MyCZEMAPIClass.Set_PassedTypeSingle('AP_STIG_X',startStigX);
GuiGlobalsStruct.MyCZEMAPIClass.Set_PassedTypeSingle('AP_STIG_Y',startStigY);



AFscanRate = GuiGlobalsStruct.MontageParameters.AutofunctionScanrate;
AFImageStore= GuiGlobalsStruct.MontageParameters.AutoFunctionImageStore;



startScanRot = sm.Get_ReturnTypeSingle('AP_SCANROTATION');
CurrentWorkingDistance = sm.Get_ReturnTypeSingle('AP_WD');




targetFocus = GuiGlobalsStruct.MontageParameters.IsTargetFocus;
if targetFocus %figure out what's going on here %chch
    %%
    targFocFig = figure;
    colormap gray(256)
    GuiGlobalsStruct.MyCZEMAPIClass.Set_PassedTypeSingle('DP_EXT_SCAN_CONTROL',1);
    
    ImageHeightInPixels = 200;
    ImageWidthInPixels = 200;
    DwellTimeInMicroseconds = 1;
    FOV = GuiGlobalsStruct.MontageParameters.TileFOV_microns;
     if GuiGlobalsStruct.MontageParameters.Is4square
         FOV = FOV * 3;
     end
    
    if exist(GuiGlobalsStruct.TempImagesDirectory,'dir')
        FileName = [GuiGlobalsStruct.TempImagesDirectory '\tempFoc.tif'];
    else
        FileName = 'C:\temp\temFoc.tif';
    end
    
    s = FOV/ImageHeightInPixels/1000000; %scale meters per pixel
    
    %Reset initial WD using AFStartingWDd from Montage Parameters
    GuiGlobalsStruct.MyCZEMAPIClass.Set_PassedTypeSingle('AP_WD',GuiGlobalsStruct.MontageParameters.AFLastWD);   %chch wasn't this done at lines 14 & 18 already?
        
    %Reset initial stig values using StartingStigX and StartingStigY from
    %Montage Parameters
    
    stage_x = GuiGlobalsStruct.MyCZEMAPIClass.Get_ReturnTypeSingle('AP_STAGE_AT_X');
    stage_y = GuiGlobalsStruct.MyCZEMAPIClass.Get_ReturnTypeSingle('AP_STAGE_AT_Y');
    stage_z = GuiGlobalsStruct.MyCZEMAPIClass.Get_ReturnTypeSingle('AP_STAGE_AT_Z');
    stage_t = GuiGlobalsStruct.MyCZEMAPIClass.Get_ReturnTypeSingle('AP_STAGE_AT_T');
    stage_r = GuiGlobalsStruct.MyCZEMAPIClass.Get_ReturnTypeSingle('AP_STAGE_AT_R');
    stage_m = GuiGlobalsStruct.MyCZEMAPIClass.Get_ReturnTypeSingle('AP_STAGE_AT_M');
    
    %%Take overview image
    
    sm.Set_PassedTypeSingle('AP_SCANROTATION',0);
    sm.Fibics_WriteFOV(FOV);
    %Wait for image to be acquired
    sm.Fibics_AcquireImage(ImageWidthInPixels,ImageHeightInPixels,DwellTimeInMicroseconds,FileName);
    while(sm.Fibics_IsBusy)
        pause(.01); %1
    end
    
    %Wait for file to be written
    IsReadOK = false;
    while ~IsReadOK
        IsReadOK = true;
        try
            I = double(imread(FileName));
        catch MyException
            IsReadOK = false;
            pause(0.1);
        end
    end
    
    image(I)
    pause(.1)
    %%find signal
    horiz = abs(I(:,1:end-1) - I(:,2:end));
    vert = abs(I(1:end-1,:) - I(2:end,:));
    difI = I*0;
    difI(1:end-1,:) = difI(1:end-1,:)+vert;
    difI(:,1:end-1) = difI(:,1:end-1)+horiz;
    
    %difI(difI>250) = 0;
    
    sat = (I<20) | ( I > 235);
    SE = strel('disk',3);
    satD = imdilate(sat,SE);
    satF = imgaussfilt(double(satD),5);
    difI(satD) = 0;
    difI = difI-(satF*255);
    
    focKern = ones(15,15);
    focKern = focKern/sum(focKern(:));
    fI= conv2(double(difI),focKern,'same');
    
    [domeY domeX] = ind2sub(size(fI),1:(size(fI,1)*size(fI,2)));
    domeDist = sqrt((domeY-mean(domeY)).^2 + (domeX-mean(domeX)).^2);
    dome = fI *0;
    dome(:) = domeDist.^10;
    dome = dome * max(fI(:))/max(dome(:));
    fIdomed = fI-dome;
    %fIdomed = fI;
    
    [y x] = find(fIdomed == max(fIdomed(:)),1);
    
    %Karl is moving the spot manually a little bit adjacent
    y=y+10;
    x=x+10;
    
    image(fI),pause(.01)
    image(fIdomed),pause(.01)
    hold on
    scatter(x,y,'x','r')
    hold off
    image(I),pause(.01)
    hold on
    scatter(x,y,'x','r')
    hold off
    
    
    
    yshift = y - ImageHeightInPixels/2;
    xshift = x - ImageHeightInPixels/2;
    
    %%move stage to signal position
    pause(.01)
    
    %sm.Set_PassedTypeSingle('AP_Mag',150);
    sm.Set_PassedTypeSingle('DP_EXT_SCAN_CONTROL',0);
    focusPosition = [stage_x - xshift * s stage_y + yshift * s];
    sm.MoveStage(focusPosition(1),focusPosition(2),stage_z,stage_t,stage_r,stage_m);
    while (strcmp(lower(GuiGlobalsStruct.MyCZEMAPIClass.Get_ReturnTypeString('DP_STAGE_IS')),'busy'))
        pause(.01)
    end
    
    wmBackLash
    pause(.1) 
    close(targFocFig)
    %%
end


%% Start Autofocus
sm.Set_PassedTypeSingle('DP_EXT_SCAN_CONTROL',0);

%sm.Set_PassedTypeSingle('DP_FROZEN',1);
sm.Set_PassedTypeSingle('AP_WD',lastWD );
sm.Set_PassedTypeSingle('AP_STIG_X',startStigX);
sm.Set_PassedTypeSingle('AP_STIG_Y',startStigY);
sm.Set_PassedTypeSingle('DP_AutoFunction_ScanRate',AFscanRate);
sm.Set_PassedTypeSingle('DP_IMAGE_STORE',AFImageStore);
%sm.Set_PassedTypeSingle('AP_Mag',StartingMagForAF); %Karl commented for coarse autofocus

IsNeedToReleaseFromFibics = 0;
if IsNeedToReleaseFromFibics
    %*** START: This sequence is designed to release the SEM from Fibics control
    sm.Execute('CMD_AUTO_FOCUS_FINE');
    pause(1); %chch
    sm.Execute('CMD_ABORT_AUTO');
    while ~strcmp('Idle',sm.Get_ReturnTypeString('DP_AUTO_FUNCTION'))
        pause(0.1);
    end
    sm.Set_PassedTypeSingle('AP_WD',CurrentWorkingDistance);
    
    pause(0.1);
    %*** END
end

%%%%
%sm.Set_PassedTypeSingle('DP_BEAM_BLANKED',0);
%%%%
%%LongPauseForStability
%sm.Execute('MCL_jmFocusWoble')%run for 10 sec

pause(.1); %chch
stableTime = GuiGlobalsStruct.MontageParameters.focusDelay;

if stableTime>0
    disp('Auto Focusing For Stabalization...')
    sm.Execute('CMD_AUTO_FOCUS_FINE');
    startStable = datenum(clock)
    while 1;
        while ~strcmp('Idle',sm.Get_ReturnTypeString('DP_AUTO_FUNCTION'))
            pause(0.2);
            
            testStable = datenum(clock);
            difStable = testStable - startStable;
            difSeconds = difStable*24*60*60
            if difSeconds > stableTime
                break
            end
        end
        sm.Execute('CMD_AUTO_FOCUS_FINE');
        testStable = datenum(clock);
        difStable = testStable - startStable;
        difSeconds = difStable*24*60*60;
        
        if difSeconds > stableTime
            break
        end
    end
    sm.Execute('CMD_ABORT_AUTO');
    pause(.1)
    sm.Set_PassedTypeSingle('AP_WD',CurrentWorkingDistance);
    pause(.1)
end

%% Karl's loop for autofocus
if 0
    ladder=1;%[-3,1];
    for ladderStep=1:length(ladder)
        AF_MAG = StartingMagForAF *2^ladderStep;
        if AF_MAG>32000
            AF_MAG=32000;
        end
        sm.Set_PassedTypeSingle('AP_Mag',AF_MAG);
        sm.Execute('CMD_UNFREEZE_ZONE');
        sm.Execute('CMD_AUTO_FOCUS_FINE');
        %sm.Execute('CMD_AUTO_FOCUS_COARSE');
        pause(1);
        stackLength=10;
        WD_stack=1:stackLength;
        while mean(WD_stack)~=mode(WD_stack)
            WD_stack(1:stackLength-1)=WD_stack(2:stackLength);
            WD_stack(stackLength)=sm.Get_ReturnTypeSingle('AP_WD');
            pause(0.2);
            %disp 'Oh focus youre so fine youre so fine you blow my mind';
            
        end
        sm.Execute('CMD_FREEZE_ZONE');
        disp 'HEY FOCUS!!!';
    end
    disp 'AF DONE';
end
%%

% pause(1)
% sm.Execute('CMD_UNFREEZE_ZONE');
% %sm.Execute('CMD_AUTO_FOCUS_COARSE');
% sm.Execute('CMD_AUTO_FOCUS_FINE');
%     %sm.Get_ReturnTypeString('DP_AUTO_FUNCTION')
%
% disp('Auto Focusing...');
% pause(1); %chch
% %
% % oldFoc = 0;
% % newFoc = 10;
% % while oldFoc ~= newFoc
% %    oldFoc = newFoc;
% %    newFoc = GuiGlobalsStruct.MyCZEMAPIClass.Get_ReturnTypeSingle('AP_WD')
% %    pause(.1)
% % end
%
% while ~strcmp('Idle',sm.Get_ReturnTypeString('DP_AUTO_FUNCTION'))
%     sm.Get_ReturnTypeString('DP_AUTO_FUNCTION')
%     pause(0.5);
%     'focusing...'
% end
%
%
%GuiGlobalsStruct.MyCZEMAPIClass.Set_PassedTypeSingle('AP_WD',lastWD );
%GuiGlobalsStruct.MyCZEMAPIClass.Get_ReturnTypeSingle('AP_WD')
%
%
% %Karl changed from 0.01 to 8.
% %Karl added 'sm.Set_PassedTypeSingle('DP_FROZEN',1);' Trying to stop the
% %burn
% %sm.Set_PassedTypeSingle('DP_FROZEN',1);
% pause(8);
% sm.Execute('CMD_FREEZE_ZONE');
%
% %Karl added this for the real autofocus
% sm.Set_PassedTypeSingle('AP_Mag',StartingMagForAF);
% pause(2);
% sm.Execute('CMD_UNFREEZE_ZONE');
% %sm.Execute('CMD_AUTO_FOCUS_COARSE');
% sm.Execute('CMD_AUTO_FOCUS_FINE');
% while ~strcmp('Idle',sm.Get_ReturnTypeString('DP_AUTO_FUNCTION'))
%     sm.Get_ReturnTypeString('DP_AUTO_FUNCTION')
%     pause(0.5);
%     'focusing fine... oh so fine it blows my mind HEY FOCUS'
% end
% pause(8);

ResultWD =sm.Get_ReturnTypeSingle('AP_WD');
ResultWD1 = ResultWD*1000


%% Five step focus tweak
if 1
    'autocorrFiveStep'
    acFocParam.adjustMode = 1;
    autocorrFiveStep(acFocParam)
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% RS Add
ResultStigX =sm.Get_ReturnTypeSingle('AP_STIG_X');
ResultStigY =sm.Get_ReturnTypeSingle('AP_STIG_Y');

if IsPerformAutoStig
    %*** Auto stig
    %%%%%%%%%%%%%%%
    for repeatStig = 1:1
        sm.Set_PassedTypeSingle('AP_Mag',StartingMagForAS / repeatStig);
        
        AutoWorkingDistance =sm.Get_ReturnTypeSingle('AP_WD');
        if (abs(AutoWorkingDistance - CurrentWorkingDistance) > WDResetThreshold)
            %If the WD has gone far enough from CurrentWorkingDistance
            %(=AFStartingWD),reset it to CurrentWorkingDistance (i.e.
            %AFStartingWD, which is the WD used at the beginning of this
            %calculation)
            sm.Set_PassedTypeSingle('AP_WD', CurrentWorkingDistance);
            
            %Reset stig values with uesr-specified StartingStigX and
            %StartingStigY
            sm.Set_PassedTypeSingle('AP_STIG_X',startStigX);
            sm.Set_PassedTypeSingle('AP_STIG_Y',startStigY);
            pause(.1)
        end
        %Temporary hard code settings
        sm.Set_PassedTypeSingle('AP_STIG_X',startStigX);
        sm.Set_PassedTypeSingle('AP_STIG_Y',startStigY);
        pause(.1)
        sm.Set_PassedTypeSingle('AP_Mag',StartingMagForAF / repeatStig);
        sm.Set_PassedTypeSingle('DP_AutoFunction_ScanRate',7);%AFscanRate);
        sm.Set_PassedTypeSingle('DP_IMAGE_STORE',2);%AFImageStore);
        pause(0.01);
        
        if 1
            %LogFile_WriteLine('Starting autostig');
            sm.Execute('CMD_AUTO_STIG');
        else
            %% Five step focus tweak
          
                'autocorrFiveStep'
                acFocParam.adjustMode = 2;
                autocorrFiveStep(acFocParam)
        end
        
        
        
        pause(1); %chch
        
        %%%%%%%%%%%
        
        disp('Auto Stig...');
        while ~strcmp('Idle',sm.Get_ReturnTypeString('DP_AUTO_FUNCTION'))
            pause(.1);
        end
        pause(0.1);
        ResultStigX1 = sm.Get_ReturnTypeSingle('AP_STIG_X');
        ResultStigY1 = sm.Get_ReturnTypeSingle('AP_STIG_Y');
        stig_difference_X = abs(ResultStigX1 - ResultStigX);
        stig_difference_Y = abs(ResultStigY1 - ResultStigY);
        if (stig_difference_X < GuiGlobalsStruct.MontageParameters.StigResetThreshold) && (stig_difference_Y < GuiGlobalsStruct.MontageParameters.StigResetThreshold)
            break % break out of repeating stig
        else
            'Repeating stig'
            %Reset Stig Values
            sm.Set_PassedTypeSingle('AP_STIG_X',startStigX);
            sm.Set_PassedTypeSingle('AP_STIG_Y',startStigY);
        end
        
    end %repeat Stig
    
    %*** Auto focusP
    %%%%%%%%%%%%%%%%%%%%%
    
    
    
    %%%%
    %     IsNeedToReleaseFromFibics = 0;
    %     if IsNeedToReleaseFromFibics
    %         %*** START: This sequence is designed to release the SEM from Fibics control
    %         sm.Execute('CMD_AUTO_FOCUS_FINE');
    %         pause(0.5);
    %         sm.Execute('CMD_ABORT_AUTO');
    %         while ~strcmp('Idle',sm.Get_ReturnTypeString('DP_AUTO_FUNCTION'))
    %             pause(0.02);
    %         end
    %         sm.Set_PassedTypeSingle('AP_WD',CurrentWorkingDistance);
    %
    %         pause(0.1);
    %         %*** END
    %     end
    %%%%
    
    sm.Set_PassedTypeSingle('AP_Mag',StartingMagForAF);
    pause(0.1);
    sm.Set_PassedTypeSingle('DP_AutoFunction_ScanRate',AFscanRate);
    sm.Set_PassedTypeSingle('DP_IMAGE_STORE',AFImageStore);
    
    %%%%
    pause(.2)
    %%%%
    %
    %     sm.Execute('CMD_AUTO_FOCUS_FINE');
    %     pause(0.5);
    %     disp('Auto Focusing...');
    %     while ~strcmp('Idle',sm.Get_ReturnTypeString('DP_AUTO_FUNCTION'))
    %         pause(.1);
    %     end
    %     pause(0.1);
    %
    
    
    %% Five step focus tweak
    
    sm.Set_PassedTypeSingle('DP_AutoFunction_ScanRate',AFscanRate);
    sm.Set_PassedTypeSingle('DP_IMAGE_STORE',AFImageStore);
    if 1
        'autocorrFiveStep'
        acFocParam.adjustMode = 1;
        autocorrFiveStep(acFocParam)
    end
    
    
    
    ResultWD =sm.Get_ReturnTypeSingle('AP_WD');
    
    
    sm.Set_PassedTypeSingle('DP_AutoFunction_ScanRate',AFscanRate);
    sm.Set_PassedTypeSingle('DP_IMAGE_STORE',AFImageStore)
    
    
    AutoWorkingDistance = sm.Get_ReturnTypeSingle('AP_WD');
    if (abs(AutoWorkingDistance - CurrentWorkingDistance) > WDResetThreshold)
        
        %Reset to initial WD for calculation, CurrentWorkingDistance
        %(=AFStartingWD)
        sm.Set_PassedTypeSingle('AP_WD', GuiGlobalsStruct.CurrentWorkingDistance );
        
        %Reset to initial stig values
        sm.Set_PassedTypeSingle('AP_STIG_X',startStigX);
        sm.Set_PassedTypeSingle('AP_STIG_Y',startStigY);
        pause(.1)
    end
    
end %end Autofocus AutoStig autofocus



%% Refocus
if focOptions.IsDoQualCheck
    offsetX = [0 50]/1000000;
    offsetY = [0 0 ]/1000000;
    StageX = GuiGlobalsStruct.MyCZEMAPIClass.Get_ReturnTypeSingle('AP_STAGE_AT_X');
    StageY = GuiGlobalsStruct.MyCZEMAPIClass.Get_ReturnTypeSingle('AP_STAGE_AT_Y');
    stage_z = GuiGlobalsStruct.MyCZEMAPIClass.Get_ReturnTypeSingle('AP_STAGE_AT_Z');
    stage_t = GuiGlobalsStruct.MyCZEMAPIClass.Get_ReturnTypeSingle('AP_STAGE_AT_T');
    stage_r = GuiGlobalsStruct.MyCZEMAPIClass.Get_ReturnTypeSingle('AP_STAGE_AT_R');
    stage_m = GuiGlobalsStruct.MyCZEMAPIClass.Get_ReturnTypeSingle('AP_STAGE_AT_M');
    
    focOptions.IsDoQualCheck = false;
    
    for o = 1:2
        
        ImageParams.FOV_microns = GuiGlobalsStruct.MontageParameters.AFTestImageFOV_microns;
        ImageParams.ImageWidthInPixels = GuiGlobalsStruct.MontageParameters.AFTestImageWidth_pixels;
        ImageParams.ImageHeightInPixels =GuiGlobalsStruct.MontageParameters.AFTestImageWidth_pixels;
        ImageParams.DwellTimeInMicroseconds = GuiGlobalsStruct.MontageParameters.AFTestImageDwellTime_microseconds ;
        
        [q] = takeFocusImage(focOptions, ImageParams);
        fprintf('Quality check registered %0.5g.\n',q.quality);
        %LogFile_WriteLine(sprintf('Quality check registered %0.5g.',q.quality));
        
        if q.quality <= focOptions.QualityThreshold %if bad
            disp('Image failed quality check')
            % LogFile_WriteLine(sprintf('!!!!! Autofocus failed to reach threshold %0.5g.',focOptions.QualityThreshold));
            
            %%Move over
            
            GuiGlobalsStruct.MyCZEMAPIClass.MoveStage(StageX + offsetX(o),StageY + offsetY(o),stage_z,stage_t,stage_r,stage_m);
            while (strcmp(lower(GuiGlobalsStruct.MyCZEMAPIClass.Get_ReturnTypeString('DP_STAGE_IS')),'busy'))
                pause(.02)
            end
            wmBackLash
            
            % Reset WD to initial value again
            GuiGlobalsStruct.MyCZEMAPIClass.Set_PassedTypeSingle('AP_WD', CurrentWorkingDistance);
%             GuiGlobalsStruct.MyCZEMAPIClass.Set_PassedTypeSingle('AP_STIG_X',startStigX);
%             GuiGlobalsStruct.MyCZEMAPIClass.Set_PassedTypeSingle('AP_STIG_Y',startStigY);
            pause(.5)
            
            disp('try new focus')
            'autocorrFiveStep'
            acFocParam.adjustMode = 1;
            autocorrFiveStep(acFocParam)
            
        else %if quality ok
            break
        end
    end %repeat refocus
    
    
    GuiGlobalsStruct.MyCZEMAPIClass.MoveStage(StageX,StageY,stage_z,stage_t,stage_r,stage_m);
    while (strcmp(lower(GuiGlobalsStruct.MyCZEMAPIClass.Get_ReturnTypeString('DP_STAGE_IS')),'busy'))
        pause(.02)
    end
    
end

%% Return to original settings
if targetFocus
    sm.Set_PassedTypeSingle('AP_SCANROTATION',startScanRot);
    sm.MoveStage(stage_x ,stage_y ,stage_z,stage_t,stage_r,stage_m);
    while (strcmp(lower(GuiGlobalsStruct.MyCZEMAPIClass.Get_ReturnTypeString('DP_STAGE_IS')),'busy'))
        pause(.01)
    end
    wmBackLash
end



%% Karl's autostig
% Ksecnum = str2num(GuiGlobalsStruct.MontageTarget.LabelStr);
% if (rem(Ksecnum,10)==0) && (GuiGlobalsStruct.MontageTarget.KdoAutoStig == 1)
%     %do autostig every 20 sections
%     sm.Execute('CMD_AUTO_STIG');
%     %pause(120);
%     ResultStigX1 = sm.Get_ReturnTypeSingle('AP_STIG_X');
%     ResultStigY1 = sm.Get_ReturnTypeSingle('AP_STIG_Y');
%     GuiGlobalsStruct.MontageParameters.StartingStigX=ResultStigX1;
%     GuiGlobalsStruct.MontageParameters.StartingStigY=ResultStigY1;
%     pause(1);
%     disp 'auto stig completed';
% end

%% Finish


GuiGlobalsStruct.MontageParameters.AFLastWD = sm.Get_ReturnTypeSingle('AP_WD');
disp 'finished smartTileFocus';
pause(1);
sm.Execute('CMD_FREEZE_ZONE')


