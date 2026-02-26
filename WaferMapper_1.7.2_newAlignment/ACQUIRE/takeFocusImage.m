function[q,FileNameStr] = takeFocusImage(focOptions, ImageParams)
tic
global GuiGlobalsStruct

if exist('focOptions')
    if isfield(focOptions,'WD')
        GuiGlobalsStruct.MyCZEMAPIClass.Set_PassedTypeSingle('AP_WD',focOptions.WD);
    end
    
end

MyCZEMAPIClass = GuiGlobalsStruct.MyCZEMAPIClass;

if isfield(GuiGlobalsStruct,'WaferDirectory')
    TPN = [GuiGlobalsStruct.WaferDirectory '\temp'];
else
    TPN = 'C:\Documents and Settings\Administrator\My Documents\My Pictures\tempData';
end

if ~exist(TPN,'dir')
    mkdir(TPN)
end

if exist('ImageParams', 'var')
    FOV_microns = ImageParams.FOV_microns;
    ImageWidthInPixels = ImageParams.ImageWidthInPixels;
    ImageHeightInPixels = ImageParams.ImageHeightInPixels;
    DwellTimeInMicroseconds = ImageParams.DwellTimeInMicroseconds;
else
    %use default params
    FOV_microns = 4;
    ImageWidthInPixels = 1000;
    ImageHeightInPixels = 1000;
    DwellTimeInMicroseconds = 1;
end

FileNameStr = [TPN '\TestFocus2.tif'];
delete(FileNameStr)

%% Take picture
MyCZEMAPIClass.Fibics_WriteFOV(FOV_microns); %Always set the FOV even if you are overriding with mag (might be used in some way inside Fibics)
pause(0.5); %1
MyCZEMAPIClass.Fibics_AcquireImage(ImageWidthInPixels,ImageHeightInPixels,...
    DwellTimeInMicroseconds,FileNameStr);
while(MyCZEMAPIClass.Fibics_IsBusy)
    pause(.2); %1
end

%% Evaluate picture
IsReadOK = false;
while ~IsReadOK
    IsReadOK = true;
    try
        MyDownSampledImage = imread(FileNameStr, 'PixelRegion', {[1 16 ImageWidthInPixels], [1 16 ImageWidthInPixels]});
    catch MyException
        IsReadOK = false;
        pause(0.5);
    end
end

q = checkFileQual(FileNameStr);

toc
