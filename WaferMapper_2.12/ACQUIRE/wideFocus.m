function[ck5] = wideFocus(acFocParam)

global GuiGlobalsStruct;
FileName = 'F:\temp\temFoc.tif';

sm = GuiGlobalsStruct.MyCZEMAPIClass;

sm.Set_PassedTypeSingle('DP_FREEZE_ON',2);
sm.Execute('CMD_FREEZE_ZONE');
GuiGlobalsStruct.MyCZEMAPIClass.Set_PassedTypeSingle('DP_EXT_SCAN_CONTROL',1);
GuiGlobalsStruct.MyCZEMAPIClass.Set_PassedTypeSingle('DP_BEAM_BLANKED',1);

focFig = figure;
set(focFig,'position',[100 100 1400 800]);
colormap(gray(256))

%% Pull focus options

if ~exist('acFocParam');
    acFocParam = [];
end

if isfield(acFocParam,'minCheckRange')
    minCheckRange = acFocParam.minCheckRange;
else
    minCheckRange = 0; %defalt is no minimum adjustment
end

if isfield(acFocParam,'reps')
    reps = acFocParam.reps;
else
    reps = 2; %defalt is no minimum adjustment
end

if isfield(acFocParam,'qualMode')
    qualMode = acFocParam.qualMode;
else
    qualMode = 1; %defalt qual mode is variance
end

if isfield(acFocParam,'minQualRange')
    minQualRange = acFocParam.minQualRange;
else
    minQualRange = 0.0005; %defalt qual mode is variance
end

if isfield(acFocParam,'ck5')
    ck5 = acFocParam.ck5;
else
    ck5 = []; %defalt qual mode is variance
end


%% Set focus imaging conditions
adjustString = 'AP_WD';
startingWD =sm.Get_ReturnTypeSingle(adjustString);
focStep = 100/1000000; %in microns? KARL changed from 250 to 100
ImageWidthInPixels = 256;
ImageHeightInPixels = 256;
DwellTimeInMicroseconds = 1; %Karl changed from 1
scanTime = ImageWidthInPixels * ImageHeightInPixels * DwellTimeInMicroseconds * 1.3 /1000000; %in seconds
%PixelSize = 4; % target pixel size in nanometers
%FOV = ImageWidthInPixels * PixelSize/1000; % Field of view in micrometers
FOV = 100;



%% Start autofocus

sm.Fibics_WriteFOV(FOV); % set autofocus field of view

WD = startingWD;
stepNum = 13;
ckN = [1:stepNum] * focStep - ceil(stepNum/2)*focStep + WD;

clear recQual recWD
trackQual = ckN * 0;
Iall = zeros(ImageHeightInPixels, ImageWidthInPixels, stepNum);

for r = 1 : reps % repeat image, check, adjust
    %disp(sprintf('%.14f \r',ckN))
    subplot(1,reps,r);
    for c = 1:length(ckN)
       
        sm.Set_PassedTypeSingle(adjustString,ckN(c));
        pause(.1)
        takePic(sm,ImageWidthInPixels,ImageHeightInPixels,DwellTimeInMicroseconds,FileName)
        I = double(imread(FileName));
        Iall(:,:,c) = I;
%         vars(c) = var(I(:));
%         means(c) = mean(I(:));
%        
        
        if qualMode == 1 %Use simple variance
            if 0
                Iqual = var(I(:));
            elseif 0
                In = I; %I/mean(I(:));%(I-mean(I(:)));
                kern1 = fspecial('disk',2);
                %If = imfilter(In,kern1,'replicate');
                If = imfilter(In, ones(3)/9);
                Iqual = var(If(:));
            else
                difY = I(1:end-1,:) - I(2:end,:);
                difX = I(:,1:end-1) - I(:,2:end);
                Iqual = mean(abs([difY(:); difX(:)]))/mean(I(:));
            end
        else %use autocorrelation
            acQual = autocorrQual(I);
            Iqual = acQual.foc_est;
           
        end
        trackQual(c) = Iqual;
        image(255-I)
        axis('off')
        title(sprintf('%0.7f',trackQual(c)));
        pause(.01)
    end
    
    
    recQual(r,:) = trackQual;
    recWD(r,:) = ckN;
    qualVar(r) = max(trackQual)-min(trackQual);
    [sortQual ord] = sort(trackQual,'descend');
    image(255-Iall(:,:,ord(1)));
    disp(trackQual)
    
    disp('zoom in')
    focStep = focStep/4;
    bestWD = ckN(ord(1));
    ckN = [1:stepNum] * focStep - ceil(stepNum/2)*focStep + bestWD;
    
end
close(focFig)


    function takePic(sm,ImageWidthInPixels,ImageHeightInPixels,DwellTimeInMicroseconds,FileName)
      
        pauseTime = ImageWidthInPixels * ImageHeightInPixels * DwellTimeInMicroseconds/1000000 * 2;
        sm.Fibics_AcquireImage(ImageWidthInPixels,ImageHeightInPixels,DwellTimeInMicroseconds,FileName);
       
        %Wait for file to be written
        
        while(sm.Fibics_IsBusy)
            pause(.01); %1
        end
        
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
        pause(pauseTime)
       sm.Set_PassedTypeSingle('DP_BEAM_BLANKED',1);

       



