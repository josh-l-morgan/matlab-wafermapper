function[] = autocorrFocus(acFocParam)

global GuiGlobalsStruct;

sm = GuiGlobalsStruct.MyCZEMAPIClass;

adjustMode = acFocParam.adjustMode;

adjustString{1} = 'AP_WD';
adjustString{2} = 'AP_STIG_X';
adjustString{3} = 'AP_STIG_Y';

startingWD =sm.Get_ReturnTypeSingle(adjustString{adjustMode});

if adjustMode == 1
    focStep = 20/1000000;
elseif adjustMode == 2
    focStep = .3;
elseif adjustMode == 3
    focStep = .3;
end


%% Set focus imaging conditions
ImageWidthInPixels = 512;
ImageHeightInPixels = 512;
DwellTimeInMicroseconds = 1;
PixelSize = 4; % target pixel size in nanometers
FOV = ImageWidthInPixels * PixelSize/1000; % Field of view in micrometers
reps = 40; %max number of autofocus checks



% if exist(GuiGlobalsStruct.TempImagesDirectory,'dir')
%     FileName = [GuiGlobalsStruct.TempImagesDirectory '\tempFoc.tif']
% else
FileName = 'D:\temp\temFoc.tif';
% end

%% Get scope starting conditions
%startingWD =sm.Get_ReturnTypeSingle(adjustString{adjustMode});
% startStigX =sm.Get_ReturnTypeSingle('AP_STIG_X');
% startStigY =sm.Get_ReturnTypeSingle('AP_STIG_Y');
% stage_x = sm.Get_ReturnTypeSingle('AP_STAGE_AT_X');
% stage_y = sm.Get_ReturnTypeSingle('AP_STAGE_AT_Y');
% stage_z = GuiGlobalsStruct.MyCZEMAPIClass.Get_ReturnTypeSingle('AP_STAGE_AT_Z');
% stage_t = GuiGlobalsStruct.MyCZEMAPIClass.Get_ReturnTypeSingle('AP_STAGE_AT_T');
% stage_r = GuiGlobalsStruct.MyCZEMAPIClass.Get_ReturnTypeSingle('AP_STAGE_AT_R');
% stage_m = GuiGlobalsStruct.MyCZEMAPIClass.Get_ReturnTypeSingle('AP_STAGE_AT_M');



%% Start autofocus

sm.Fibics_WriteFOV(FOV); % set autofocus field of view

WD = startingWD;
ck4 = [WD - focStep WD WD + focStep WD + focStep*2];
clear recQual recWD
checkWDs = [1 1 1 1];
trackQual = ck4 * 0;
missHits = 0;
for r = 1 : reps % repeat image, check, adjust
   % disp(sprintf('%.4f',ck4))
    
    %% run four points
    for c = 1:length(ck4)
        %% Set working distance
        if checkWDs(c)
            sm.Set_PassedTypeSingle(adjustString{adjustMode},ck4(c));
            takePic(ImageWidthInPixels,ImageHeightInPixels,DwellTimeInMicroseconds,FileName)
            I = imread(FileName);
            subplot(1,4,c)
            image(I)
            pause(.01)
            if acFocParam.qualMode == 1 %Use simple variance
                Iqual = var(double(I(:)));
            else %use autocorrelation
                acQual = autocorrQual(I);
                if acFocParam.adjustMode == 1
                    Iqual = acQual.foc_est;
                elseif acFocParam.adjustMode == 2
                    Iqual = acQual.astgx_est;
                else
                    Iqual = acQual.astgy_est;
                end
            end
            trackQual(c) = Iqual;
        end
    end
    
    recQual(r,:) = trackQual;
    recWD(r,:) = ck4;
    qualVar(r) = max(trackQual)-min(trackQual);
    
    [sortQual ord] = sort(trackQual,'descend');
    
    trackQual
    if abs(ord(1)-ord(2))>1 % if first and second values are not together
        checkWDs = [1 1 1 1];
        missHits = missHits + 1; %focus not structured
    elseif (ord(1) == 4) | ( ord(2) == 4) %top end is best
        
        addFoc = ck4(end) + focStep;
        ck4 = [ck4(2:4) addFoc];
        trackQual(1:3) = trackQual(2:4);
        checkWDs = [0 0 0 1];
        
    elseif (ord(1) == 1) | ( ord(2) == 1) % bottom end is best
        addFoc = ck4(1) - focStep;
        ck4 = [addFoc ck4(1:3)];
        trackQual(2:4) = trackQual(1:3);
        checkWDs = [1 0 0 0];
        
    else
        'enhance'
        focStep = focStep/2;
        ck4 = [ck4(2) ck4(2)+focStep ck4(3)-focStep ck4(3)];
        trackQual([1 4]) = trackQual([2 3]);
        checkWDs = [0 1 1 0];
    end
    
        checkWDs

        if missHits>3
            'focus changes not structured'
            break
        end
            
    
    %     if r>3
    %         if qualVar(end)< qualVar(end-1)
    %             'done'
    %             break
    %         end
    %     end
    r
end

    function takePic(ImageWidthInPixels,ImageHeightInPixels,DwellTimeInMicroseconds,FileName)
        
        sm.Fibics_AcquireImage(ImageWidthInPixels,ImageHeightInPixels,DwellTimeInMicroseconds,FileName);
        while(sm.Fibics_IsBusy)
            pause(.01); %1
        end
        
        %Wait for file to be written
        IsReadOK = false;
        while ~IsReadOK
            IsReadOK = true;
            try
                I = imread(FileName);
            catch MyException
                IsReadOK = false;
                pause(0.1);
            end
        end
    end

end

