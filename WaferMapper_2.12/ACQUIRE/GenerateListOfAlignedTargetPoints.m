%GenerateListOfAlignedTargetPoints




%NOTE: This function starts at the currently open section inthe WaferMapper GUI and crops the region of the
%SectionOverview image that is defined by the LowResForAlign box. It then
%goes to section2 and does a software alignment to this and recordes the
%offset needed to align these. It continues to the last section

global GuiGlobalsStruct;


%Determine the wafer name of the image currently displayed
PopupMenuIndex = get(handles.WaferForSectionOverviewDisplay_PopupMenu,'Value');
PopupMenuCellArray = get(handles.WaferForSectionOverviewDisplay_PopupMenu,'String');
WaferName_InDisplay = PopupMenuCellArray{PopupMenuIndex};
SectionNumStr = get(handles.SectionLabel_EditBox,'String');
NumberOfSections = length(GuiGlobalsStruct.CoarseSectionList);

SectionToAlignTo_WaferNameIndex = PopupMenuIndex;
SectionToAlignTo_SectionIndex = str2num(SectionNumStr);


MyStr = sprintf('Sections will be aligned from WaferName=%s, (WaferNameIndex=%d), SectionNum=%d. Press OK to proceed.',...
    WaferName_InDisplay, SectionToAlignTo_WaferNameIndex, SectionToAlignTo_SectionIndex);

AnswerStr = questdlg(MyStr, 'Question', 'OK', 'Cancel', 'OK'); %Return key default: OK

if isempty(AnswerStr | strcmp(AnswerStr, 'Cancel')) %canceled
   fprintf('Canceled\n');
   return; 
end

MyStr = sprintf('Create aligned target list only for WaferName=%s?', WaferName_InDisplay);
AnswerStr = questdlg(MyStr, 'Question', 'Just This Wafer', 'All Wafers', 'Just This Wafer');
if isempty(AnswerStr) %canceled
    fprintf('Canceled\n');
    return; 
end
IsDoJustThisWafer = strcmp(AnswerStr, 'Just This Wafer');

%Setup how many images will be averaged to align with
if NumberOfSections >10
NumberOfPreviousImages = 2;
else
    NumberOfPreviousImages = 0;
end
uiwait(msgbox(sprintf('Number of images to use for running average = %d. Press OK to continue.', NumberOfPreviousImages)));



%Save everythin in the following structure then save at end
AlignedTargetList.LowResForAlignWidthInMicrons = GuiGlobalsStruct.MontageTarget.LowResForAlignWidthInMicrons;
AlignedTargetList.LowResForAlignHeightInMicrons = GuiGlobalsStruct.MontageTarget.LowResForAlignHeightInMicrons;
AlignedTargetList.MicronsPerPixel = GuiGlobalsStruct.MontageTarget.MicronsPerPixel;
AlignedTargetList.AF_X_Offset_Microns = GuiGlobalsStruct.MontageTarget.AF_X_Offset_Microns;
AlignedTargetList.AF_Y_Offset_Microns = GuiGlobalsStruct.MontageTarget.AF_Y_Offset_Microns;

%Create directory if needed
if ~isfield(GuiGlobalsStruct, 'AlignedTargetListsDirectory')
    GuiGlobalsStruct.AlignedTargetListsDirectory = sprintf('%s\\AlignedTargetListsDirectory',GuiGlobalsStruct.UTSLDirectory);
end

if ~exist( GuiGlobalsStruct.AlignedTargetListsDirectory, 'dir')
    %[SUCCESS,MESSAGE,MESSAGEID] = MKDIR(PARENTDIR,NEWDIR)
    [SUCCESS,MESSAGE,MESSAGEID] = mkdir(GuiGlobalsStruct.UTSLDirectory, 'AlignedTargetListsDirectory');
    if ~SUCCESS
        MyStr = sprintf('Could not create: %s', GuiGlobalsStruct.AlignedTargetListsDirectory);
        fprintf('Could not create: %s\n', GuiGlobalsStruct.AlignedTargetListsDirectory);
        uiwait(msgbox(MyStr));
        return;
    end
end

%Ask for name of this AlignedTargetList and make a directory
MyAnswer = inputdlg('Enter new name for this AlignedTargetList');
if ~isempty(MyAnswer) %empty if user canceled
    NewDirectory = sprintf('%s\\%s',GuiGlobalsStruct.AlignedTargetListsDirectory,MyAnswer{1});
    if exist(NewDirectory)
        MyStr = sprintf('Directory already exists: %s', NewDirectory);
        uiwait(msgbox(MyStr));
        return;
    end
    
    [SUCCESS,MESSAGE,MESSAGEID] = mkdir(GuiGlobalsStruct.AlignedTargetListsDirectory, MyAnswer{1});
    if ~SUCCESS
        MyStr = sprintf('Could not create: %s', NewDirectory);
        fprintf('%s\n',MyStr);
        uiwait(msgbox(MyStr));
        return;
    end

else
    return;
end


%Setup WAITBAR
%Perform quick calculation of how many images will be aligned. This is ONLY FOR WAITBAR
if IsDoJustThisWafer
    WaferName = GuiGlobalsStruct.ListOfWaferNames{SectionToAlignTo_WaferNameIndex};
    CoarseSectionListFileNameStr = sprintf('%s\\%s\\FullWaferTileImages\\CoarseSectionList.mat',...
        GuiGlobalsStruct.UTSLDirectory, WaferName);
    load(CoarseSectionListFileNameStr,'CoarseSectionList');
    Waitbar_TotalNumberOfImagesToAlign = length(CoarseSectionList);
    fprintf('About to align a total of %d images across one wafer\n', Waitbar_TotalNumberOfImagesToAlign); 
else
    Waitbar_TotalNumberOfImagesToAlign = 0;
    for WaferNameIndex = 1:length(GuiGlobalsStruct.ListOfWaferNames)
        WaferName = GuiGlobalsStruct.ListOfWaferNames{WaferNameIndex};
        CoarseSectionListFileNameStr = sprintf('%s\\%s\\FullWaferTileImages\\CoarseSectionList.mat',...
            GuiGlobalsStruct.UTSLDirectory, WaferName);
        load(CoarseSectionListFileNameStr,'CoarseSectionList');
        Waitbar_TotalNumberOfImagesToAlign = Waitbar_TotalNumberOfImagesToAlign + length(CoarseSectionList);
    end
    fprintf('About to align a total of %d images across %d wafers\n',Waitbar_TotalNumberOfImagesToAlign, length(GuiGlobalsStruct.ListOfWaferNames)); 
end
GuiGlobalsStruct.IsUserCancelWaitBar = false;
%GuiGlobalsStruct.h_waitbar = waitbar(0,'Generating aligned target points...',  'WindowStyle' , 'modal', 'CreateCancelBtn', 'UserCancelWaitBar();');
GuiGlobalsStruct.h.showAlignFig = figure('Position',[317 394 1406 504],'colormap',gray(256)); %steals window focus
GuiGlobalsStruct.h.showAlignAx= gca(GuiGlobalsStruct.h.showAlignFig); %no longer used
%move subplot()s to here outside of For loop
ax1 = subplot(1,2,1, GuiGlobalsStruct.h.showAlignFig.CurrentAxes);
ax2 = subplot(1,2,2);

Waitbar_SectionNumber = 1;

%perform actual alignments
for FowardBackwardIndex = 1:2
    clear OriginalImage
    if FowardBackwardIndex == 1
        IsGoingForward = true;
    else
        IsGoingForward = false;
    end
    
    %Setup how many images will be averaged to align with
    %NumberOfPreviousImages = 10; %set above
    for i = 1:NumberOfPreviousImages
        PreviousImagesArray(i).Image = [];
    end
    MeanOfPreviousImages = [];
    
    if  IsGoingForward
        StartingWaferNameIndex = SectionToAlignTo_WaferNameIndex;
        WaferNameIndexIncrementSign = 1;
        if IsDoJustThisWafer
            EndingWaferNameIndex = StartingWaferNameIndex;
        else
            EndingWaferNameIndex = length(GuiGlobalsStruct.ListOfWaferNames);
        end
    else
        StartingWaferNameIndex = SectionToAlignTo_WaferNameIndex;
        WaferNameIndexIncrementSign = -1;
        if IsDoJustThisWafer
            EndingWaferNameIndex = StartingWaferNameIndex;
        else
            EndingWaferNameIndex = 1;
        end
    end
    
    for WaferNameIndex = StartingWaferNameIndex:WaferNameIndexIncrementSign:EndingWaferNameIndex
        
        
        
        AlignedTargetList.ListOfWaferNames  = GuiGlobalsStruct.ListOfWaferNames;
        
        
        WaferName = GuiGlobalsStruct.ListOfWaferNames{WaferNameIndex}
        CoarseSectionListFileNameStr = sprintf('%s\\%s\\FullWaferTileImages\\CoarseSectionList.mat',...
            GuiGlobalsStruct.UTSLDirectory, WaferName);
        load(CoarseSectionListFileNameStr,'CoarseSectionList');
        
        
        if  IsGoingForward
            if WaferNameIndex == StartingWaferNameIndex
                StartingSectionIndex = SectionToAlignTo_SectionIndex;
            else
                StartingSectionIndex = 1;
            end
            SectionIndexIncrementSign = 1;
            EndingSectionIndex = length(CoarseSectionList);
        else
            if WaferNameIndex == StartingWaferNameIndex
                StartingSectionIndex = SectionToAlignTo_SectionIndex;
            else
                StartingSectionIndex = length(CoarseSectionList);
            end
            SectionIndexIncrementSign = -1;
            EndingSectionIndex = 1;
        end
        
        for SectionIndex = StartingSectionIndex:SectionIndexIncrementSign:EndingSectionIndex
            LabelStr = CoarseSectionList(SectionIndex).Label;
            
            
            %WAITBAR stuff
            if exist('SecondsToAlignedPreviousSection', 'var')
                UpdatedMessageStr = sprintf('# %d of %d. Time to complete %0.5g min', Waitbar_SectionNumber, Waitbar_TotalNumberOfImagesToAlign, ...
                    ((Waitbar_TotalNumberOfImagesToAlign-(Waitbar_SectionNumber-1))*SecondsToAlignedPreviousSection)/60);
            else
                UpdatedMessageStr = sprintf('Aligning section# %d of %d. Time to complete ...', Waitbar_SectionNumber, Waitbar_TotalNumberOfImagesToAlign);
            end
            %waitbar(Waitbar_SectionNumber/Waitbar_TotalNumberOfImagesToAlign,GuiGlobalsStruct.h_waitbar, UpdatedMessageStr);
            if GuiGlobalsStruct.IsUserCancelWaitBar
               'meow'
                return;
            end
            StartTimeOfThisSection = tic;
            
            
            AlignedTargetList.WaferArray(WaferNameIndex).SectionArray(SectionIndex).LabelStr = LabelStr;
            
            
            ImageFileNameStr = sprintf('%s\\%s\\SectionOverviewsAlignedWithTemplateDirectory\\SectionOverviewAligned_%s.tif',...
                GuiGlobalsStruct.UTSLDirectory, WaferName, LabelStr);
            
            r = round(GuiGlobalsStruct.MontageTarget.r);
            c = round(GuiGlobalsStruct.MontageTarget.c);
            half_w = round(0.5*(GuiGlobalsStruct.MontageTarget.LowResForAlignWidthInMicrons/GuiGlobalsStruct.MontageTarget.MicronsPerPixel));
            half_h = round(0.5*(GuiGlobalsStruct.MontageTarget.LowResForAlignHeightInMicrons/GuiGlobalsStruct.MontageTarget.MicronsPerPixel));
            
            AlignedTargetList.WaferArray(WaferNameIndex).SectionArray(SectionIndex).ImageFileNameStr = ImageFileNameStr;
            AlignedTargetList.WaferArray(WaferNameIndex).SectionArray(SectionIndex).r = r;
            AlignedTargetList.WaferArray(WaferNameIndex).SectionArray(SectionIndex).c = c;
            AlignedTargetList.WaferArray(WaferNameIndex).SectionArray(SectionIndex).half_w = half_w;
            AlignedTargetList.WaferArray(WaferNameIndex).SectionArray(SectionIndex).half_h = half_h;
            
            
            NewImage = imread(ImageFileNameStr, 'PixelRegion',...
                {[r-half_h r+half_h], [c-half_w c+half_w]});
            
            NewImage = mexHatTarget(NewImage);
           
            IsPlotResults = true; %debugging
            subplot(1,2,1) %for 2022 versions remove to avoid window stealing focus
            if IsPlotResults
                ax1.Title.String = sprintf('%s, Section# %s',WaferName,LabelStr); %old: title(myStr);
                image(NewImage+100);
                drawnow;
            end
            
            AnglesInDegreesToTryArray = [- 2 -1 0 1 2]/2; %Note: Should be pretty close from overview alignment
            %             if ~isempty(MeanOfPreviousImages) %KH KH KH Remove this it is to deal with bad first section!!!
            %                 OriginalImage = uint8(MeanOfPreviousImages);
            %             else
            %                 OriginalImage = NewImage; %just align first with it self for simplicity of code
            %             end
            if ~exist('OriginalImage')
                OriginalImage = NewImage;
            end
            doAutoTargetPointAlignment = 1;
            if doAutoTargetPointAlignment
                fprintf('%s\n',CoarseSectionListFileNameStr');
                tic
                [XOffsetOfNewInPixels, YOffsetOfNewInPixels, AngleOffsetOfNewInDegrees] =...
                    CalcPixelOffsetAndAngleBetweenTwoImages(OriginalImage, NewImage, AnglesInDegreesToTryArray)
                toc
            else
                XOffsetOfNewInPixels =0;
                YOffsetOfNewInPixels = 0;
                AngleOffsetOfNewInDegrees  = 0;
            end
            %*** create a new aligned image 'NewImage_shifted' *********************************
            r_offset = YOffsetOfNewInPixels; %Note: Here is where the reversed Y-Axis sign change is fixed
            c_offset = - XOffsetOfNewInPixels;
            New_r = r - r_offset;
            New_c = c - c_offset;
            %now use these to grab a new image from the aligned overview
            NewImage_shifted = imread(ImageFileNameStr, 'PixelRegion',...
                {[New_r-half_h New_r+half_h], [New_c-half_w New_c+half_w]});
            NewImage_shifted = imrotate(NewImage_shifted,AngleOffsetOfNewInDegrees,'crop');
            
            
            %Also grab a 3x larger image centered at same region
            NewImage_x3LargerROI_shifted = imread(ImageFileNameStr, 'PixelRegion',...
                {[New_r-(half_h*3+1) New_r+(half_h*3+1)], [New_c-(half_w*3+1) New_c+(half_w*3+1)]});
            NewImage_x3LargerROI_shifted = imrotate(NewImage_x3LargerROI_shifted,AngleOffsetOfNewInDegrees,'crop');
            
            subplot(1,2,2) %for 2022 versions remove to avoid window stealing focus
            if IsPlotResults
                image(NewImage_shifted);
            end
            
            ImageFileNameStr = sprintf('%s\\LowResAligned_%s_Section_%s.tif',...
                    NewDirectory, WaferName, LabelStr);
            fprintf('Writing file: %s\n',ImageFileNameStr);
            imwrite(NewImage_shifted, ImageFileNameStr, 'tif');
            
            ImageFile_x3LargerROI_NameStr = sprintf('%s\\LowResAligned_x3LargerROI_%s_Section_%s.tif',...
                NewDirectory, WaferName, LabelStr);
            fprintf('Writing file: %s\n',ImageFile_x3LargerROI_NameStr);
            imwrite(NewImage_x3LargerROI_shifted, ImageFile_x3LargerROI_NameStr, 'tif');
            
            AlignedTargetList.WaferArray(WaferNameIndex).SectionArray(SectionIndex).XOffsetOfNewInPixels = XOffsetOfNewInPixels;
            AlignedTargetList.WaferArray(WaferNameIndex).SectionArray(SectionIndex).YOffsetOfNewInPixels = YOffsetOfNewInPixels;
            AlignedTargetList.WaferArray(WaferNameIndex).SectionArray(SectionIndex).AngleOffsetOfNewInDegrees = AngleOffsetOfNewInDegrees;
            
            %Update the previous image history and MeanOfPreviousImages with this new aligned image
%             for i = 1:NumberOfPreviousImages
%                 ArrayIndex = (NumberOfPreviousImages-i)+1;
%                 if ArrayIndex > 1
%                     PreviousImagesArray(ArrayIndex).Image = PreviousImagesArray(ArrayIndex-1).Image;
%                 else
%                     PreviousImagesArray(ArrayIndex).Image = double(NewImage_shifted);
%                 end
%             end
%             n = 0;
%             MeanOfPreviousImages = 0*double(NewImage);
%             for i = 1:NumberOfPreviousImages
%                 if ~isempty(PreviousImagesArray(i).Image)
%                     n=n+1;
%                     MeanOfPreviousImages = MeanOfPreviousImages + PreviousImagesArray(i).Image;
%                 end
%             end
%             MeanOfPreviousImages = MeanOfPreviousImages/n;
            
            
            %Load section overview AlignmentDataFile and copy info into this section's file
            DataFileNameStr = sprintf('%s\\%s\\SectionOverviewsDirectory\\SectionOverview_%s.mat',...
                GuiGlobalsStruct.UTSLDirectory, WaferName, LabelStr);
            
            AlignmentDataFileNameStr = sprintf('%s\\%s\\SectionOverviewsAlignedWithTemplateDirectory\\SectionOverviewAligned_%s.mat',...
                GuiGlobalsStruct.UTSLDirectory, WaferName, LabelStr);
            
            if exist(DataFileNameStr, 'file') && exist(AlignmentDataFileNameStr, 'file')
                load(DataFileNameStr, 'Info');
                load(AlignmentDataFileNameStr, 'AlignmentParameters');
            else
                MyStr = sprintf('Could not find %s and/or %s',DataFileNameStr, AlignmentDataFileNameStr);
                uiwait(msgbox(MyStr));
                'bark'
                return;
            end
            
            AlignedTargetList.WaferArray(WaferNameIndex).SectionArray(SectionIndex).SectionOveriewInfo = Info;
            AlignedTargetList.WaferArray(WaferNameIndex).SectionArray(SectionIndex).AlignmentParameters = AlignmentParameters;
            
            
            TocAfterAllProcessing = toc(StartTimeOfThisSection);
            fprintf('   Time for full processing of this section %0.5g seconds\n', TocAfterAllProcessing);
            SecondsToAlignedPreviousSection = TocAfterAllProcessing;
            Waitbar_SectionNumber = Waitbar_SectionNumber + 1;
        end
              
    end
    
end


DataFileNameStr = sprintf('%s\\AlignedTargetList.mat',NewDirectory);
save(DataFileNameStr, 'AlignedTargetList');

pause(1)
close(GuiGlobalsStruct.h.showAlignFig); 


% if ishandle(GuiGlobalsStruct.h_waitbar)
%      delete(GuiGlobalsStruct.h_waitbar);
% end