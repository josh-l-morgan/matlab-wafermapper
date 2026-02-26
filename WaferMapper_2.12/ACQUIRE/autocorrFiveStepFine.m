function[ck5] = autocorrFiveStepFine(acFocParam)

global GuiGlobalsStruct;
sm = GuiGlobalsStruct.MyCZEMAPIClass;

GuiGlobalsStruct.MyCZEMAPIClass.Set_PassedTypeSingle('DP_FREEZE_ON',2);


sm.Execute('CMD_FREEZE_ZONE');

GuiGlobalsStruct.MyCZEMAPIClass.Set_PassedTypeSingle('DP_EXT_SCAN_CONTROL',1);
GuiGlobalsStruct.MyCZEMAPIClass.Set_PassedTypeSingle('DP_BEAM_BLANKED',1);

focFig = figure;


focAx = gca;
set(focFig,'position',[100 100 1200 1000]);

axS = subplot(5,5,[1:4 6:9 11:14 16:19 ]);
axis off
for c = 1:5
    axI{c} = subplot(5,5,c*5);
    axis off
end
axP =subplot(5,5,[21:24]);
axis off


colormap(gray(256))

%% Pull focus options

if ~exist('acFocParam');
    acFocParam = [];
end


if isfield(acFocParam,'ns')
    reps = acFocParam.ns;
else
    ns = 1; %defalt is no minimum adjustment
end

if isfield(acFocParam,'adjustMode')
    adjustMode = acFocParam.adjustMode;
else
    adjustMode = 1; %default is focus
end


if isfield(acFocParam,'PixelSize')
    PixelSize = acFocParam.PixelSize;
else
    PixelSize = 16; %4; % target pixel size in nanometers
end

if isfield(acFocParam,'minCheckRange')
    minCheckRange = acFocParam.minCheckRange;
else
    minCheckRange = 0; %defalt is no minimum adjustment
end

if isfield(acFocParam,'reps')
    reps = acFocParam.reps;
else
    reps = 20; %defalt is no minimum adjustment
end

if isfield(acFocParam,'qualMode')
    qualMode = acFocParam.qualMode;
else
    qualMode = 1; %defalt qual mode is variance
end

if isfield(acFocParam,'minQualRange')
    minQualRange = acFocParam.minQualRange;
else
    minQualRange = 0;%0.0005; %defalt qual mode is variance
end

if isfield(acFocParam,'ck5')
    ck5 = acFocParam.ck5;
else
    ck5 = []; %defalt qual mode is variance
end
%%
adjustString{1} = 'AP_WD';
adjustString{2} = 'AP_STIG_X';
adjustString{3} = 'AP_STIG_Y';

startingWD =sm.Get_ReturnTypeSingle(adjustString{adjustMode});



if isfield(acFocParam, 'focStep')
    focStep = acFocParam.focStep;
else
    
    if adjustMode == 1
        focStep = 1/1000000; %in microns? KARL changed from 250 to 100
    elseif adjustMode == 2
        focStep = .3;
    elseif adjustMode == 3
        focStep = .3;
    end
end


%% Set focus imaging conditions
ImageWidthInPixels = 512;
ImageHeightInPixels = 512;
DwellTimeInMicroseconds = 1;%0.2; %Karl changed from 1
scanTime = ImageWidthInPixels * ImageHeightInPixels * DwellTimeInMicroseconds * 1.3 /1000000; %in seconds
FOV = ImageWidthInPixels * PixelSize/1000; % Field of view in micrometers

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

if isempty(ck5)
    ck5 = [WD - focStep*2 WD - focStep WD WD + focStep WD + focStep*2];
else
    focStep = ck5(2)-ck5(1);
end

clear recQual recWD
checkWDs = [1 1 1 1 1];
trackQual = zeros(length(ck5),ns);
missHits = 0;
qualHits = 0;
I5 = zeros(ImageHeightInPixels,ImageWidthInPixels,5);

recFoc = zeros(reps,5);
for r = 1 : reps % repeat image, check, adjust
    %disp(sprintf('%.14f \r',ck5))
    recFoc(r,:) = ck5;
    %% run four points
    tic
    
    for n = 1:ns
        for c = 1:length(ck5)
            %% Set working distance
            if checkWDs(c)
                sm.Set_PassedTypeSingle(adjustString{adjustMode},ck5(c));
                pause(.03)
                reportScopeVal = sm.Get_ReturnTypeSingle(adjustString{adjustMode});
                tic
                takePic(sm,ImageWidthInPixels,ImageHeightInPixels,DwellTimeInMicroseconds,FileName)
                I = double(imread(FileName));
                axes(axS)
                image(255-I);
                I5(:,:,c,n) = I;
                if qualMode == 1 %Use simple variance
                    if 0
                        Iqual = var(I(:));
                    elseif 1
                        In = I; %I/mean(I(:));%(I-mean(I(:)));
                        kern1 = fspecial('disk',2);
                        %If = imfilter(In,kern1,'replicate');
                        %If = imfilter(In, ones(3)/9);
                        If = imgaussfilt(I,1);
                        Iqual = var(If(:));
                        I5(:,:,c,n) = If;
                    else
                        difY = I(1:end-1,:) - I(2:end,:);
                        difX = I(:,1:end-1) - I(:,2:end);
                        Iqual = mean(abs([difY(:); difX(:)]))/mean(I(:));
                    end
                else %use autocorrelation
                    acQual = autocorrQual(I);
                    if adjustMode == 1
                        Iqual = acQual.foc_est;
                    elseif adjustMode == 2
                        Iqual = acQual.astgx_est;
                    else
                        Iqual = acQual.astgy_est;
                    end
                end
                trackQual(c,n) = Iqual;
            end
            
            
            %figure(focFig)
            %             axes(axI{c})
            %             image(255-I5(:,:,c));
            %
            %             title(axI{c},sprintf('%0.7f',trackQual(c)));
            
            useFoc = abs(recFoc)>0; % might need to get rid of abs
            [y x] = find(useFoc);
            v = recFoc(useFoc);
            v = (v-startingWD)*1000000;
            ck5s = (ck5 - startingWD) * 1000000;
            if (length(v) == length(y)) 
                try
                    scatter(axP,y(:),v(:),'k');
                    hold(axP,'on')
                    plot(axP,[min(y) max(y)],[min(ck5s) min(ck5s)],'r');
                    plot(axP,[min(y) max(y)],[max(ck5s) max(ck5s)],'r');
                    plot(axP,[min(y) max(y)],[mean(ck5s) mean(ck5s)],'k');
                    
                    hold(axP, 'off')
                    rng = max(ck5s)-min(ck5s);
                    shRng = [min(ck5s)-rng*10 max(ck5s)+rng*10];
                    ylim(axP,shRng)
                    xlim(axP,[min(y)-.5 max(y)+.5]);
                catch err
                    'bark'
                end
            end
            
        end
    end
    
    meanVar = zeros(length(ck5),ns);
    for c = 1:length(ck5)
        %% Set working distance
        %if checkWDs(c)
        for n = 1:ns % replace with remembered values later
            I = I5(:,:,c,n);
            meanVar(c,n) = var(I(:));
        end
        Im = mean(I5(:,:,c,:),4);
        axes(axI{c})
        image(255-Im);
        
        axis off
        trackQualM(c) = mean(meanVar(c,:));
        %end
        title(axI{c},sprintf('%0.7f',trackQualM(c)));
    end
    useQual = trackQualM;
    
    
    %% test variance
    
    %     for n = 1:ns
    %         itVar(n) = var(trackQual(:,n));
    %     end
    %     for c = 1:length(ck5)
    %         cVar(c) = var(trackQual(c,:));
    %     end
    %
    %
    %     dev = mean(std(trackQual,0,2)/sqrt(ns));
    %     meanTrack = trackQualM;
    
    %     mVar = var(meanTrack);
    
    %     focVar = mVar/mean(cVar);
    %     disp(sprintf('variance due to focus ratio = %0.3f',focVar))
    %
    %
    %
    %% make descision
    pause(.01)
    
    %     recQual(r,:) =meanTrack;
    %     qualVar(r) = max(meanTrack)-min(meanTrack);
    %     recWD(r,:) = ck5;
    
    %     for n = 1:ns
    %         allChoice(n) = pickAdjust(trackQual(:,n));
    %     end
    choice = pickAdjust(useQual)
    
    %     disp(sprintf('allChoices = %s',num2str(allChoice)))
    %     disp(sprintf('bestChoice = %d',choice))
    
    %     qualVar(r) = max(meanTrack)-min(meanTrack);
    
    disp(useQual)
    
    if choice == 1 % if first and second values are not together & best value is less than X of second best
        disp('not structured')
        checkWDs = [1 1 1 1 1];
        missHits = missHits + 1; %focus not structured
        ns = ns + 1; %sample more
        ns = min(ns,4);
        disp(sprintf('take %d images',ns))
        
        %Is the best or second best in position 1?
    elseif choice == 2 %top end is best
        disp('shift up')
        addFoc = ck5(end) + focStep;
        ck5 = [ck5(2:end) addFoc];
        I5(:,:,1:end-1,:) = I5(:,:,2:end,:);
        % trackQual(1:end-1,:) = trackQual(2:end,:);
        checkWDs = [0 0 0 0 1];
        
    elseif choice == 3 % bottom end is best
        disp('shift down')
        addFoc = ck5(1) - focStep;
        ck5 = [addFoc ck5(1:end-1)];
        I5(:,:,2:end,:) = I5(:,:,1:end-1,:);
        % trackQual(2:end,:) = trackQual(1:end-1,:);
        checkWDs = [1 0 0 0 0];
        
    else % choice == 4
        disp('zoom in')
        focStep = focStep/2;
        ck5 = [ck5(2) ck5(3)-focStep ck5(3) ck5(3)+focStep ck5(end-1)];
        I5(:,:,[1 5],:) = I5(:,:,[2 4],:);
        % trackQual([1 3 5],:) = trackQual([2 3 4],:);
        checkWDs = [0 1 0 1 0];
        
    end
    
    
    %Bail if focus/stig incriment is small
    if range(ck5) < minCheckRange
        'Adjustments below minimum range'
        break
    end
    
    %Bail if qulity difference is small
    if range(trackQual) < minQualRange
        if mean(trackQual) > 0.04
            qualHits = qualHits+1
        end
    end
    
    if missHits>3 % Karl changed from 3 to 2
        'focus changes not structured'
        break
    end
    
    if qualHits>4 % Karl changed from 3 to 2
        'qual range is miniscule'
        break
    end
    
    %     if r>3
    %         if qualVar(end)< qualVar(end-1)
    %             'done'
    %             break
    %         end
    %     end
    %disp(sprintf('Karls Qual range is %f units \r', range(trackQual)))
    %ckRange = range(ck5 * 10^9); %in nanometers
    %disp(sprintf('check range is %0.0f nm \r',ckRange))
end




close(focFig)


    function takePic(sm,ImageWidthInPixels,ImageHeightInPixels,DwellTimeInMicroseconds,FileName)
        
        pauseTime = ImageWidthInPixels * ImageHeightInPixels * DwellTimeInMicroseconds/1000000 * 1.3;
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
        pause(pauseTime)
        sm.Set_PassedTypeSingle('DP_BEAM_BLANKED',1);
        
        
        %
        %
        %         sm.Fibics_AcquireImage(ImageWidthInPixels,ImageHeightInPixels,DwellTimeInMicroseconds,FileName);
        %         c1 = 0;
        %         while(sm.Fibics_IsBusy)
        %             pause(.01); %1
        %             c1 = c1+1;
        %         end
        %         %c1
        %         %sm.Execute('CMD_FREEZE_ZONE');
        %         GuiGlobalsStruct.MyCZEMAPIClass.Set_PassedTypeSingle('DP_BEAM_BLANKED',1);
        %
        %         %Wait for file to be written
        %         IsReadOK = false;
        %         while ~IsReadOK
        %             IsReadOK = true;
        %             try
        %                 I = imread(FileName);
        %             catch MyException
        %                 IsReadOK = false;
        %                 pause(0.1);
        %             end
        %         end
    end



end

function[choice] = pickAdjust(quals)
%% sort possible choices based on quality values

[sortQual ord] = sort(quals,'descend');

if (abs(ord(1)-ord(2))>1) & ( sortQual(1)<(sortQual(2)*1.1)) % if first and second values are not together & best value is less than X of second best
    choice = 1;
elseif (ord(1) == length(quals)) | ( ord(2) == length(quals) & (quals(ord(2))>quals(ord(1))*0.9)) %top end is best
    choice = 2;
elseif (ord(1) == 1) | (( ord(2) == 1) & (quals(ord(2))>quals(ord(1))*0.9)) % bottom end is best
    choice = 3;
else
    choice = 4;
end




end


