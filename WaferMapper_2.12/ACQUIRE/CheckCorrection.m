function CheckCorrection(OriginalFiducialDirectory, ReimageFiducialsDirectory, ReimageWithCorrectionFiducialsDirectory)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
global GuiGlobalsStruct;

h_fig = figure();
set(h_fig,'Position',[320 430 1660 718])
ScaleFactorDataFileNameStr = sprintf('%s\\ComputedScaleFactor.mat',ReimageFiducialsDirectory);
if exist(ScaleFactorDataFileNameStr, 'file')
    load(ScaleFactorDataFileNameStr, 'BestScaleFactorFromFirstFiducial');
else
    BestScaleFactorFromFirstFiducial = 1;
end


FiducialNum = 1;
showList = [];
for  FiducialNum = 1:20
    FiducialNumStr = sprintf('%d',(100 + FiducialNum));
    ReimageWithCorrectionFileNameStr = sprintf('%s\\Fiducial_%s.tif',ReimageWithCorrectionFiducialsDirectory,FiducialNumStr(2:3));
    if exist(ReimageWithCorrectionFileNameStr, 'file');
        showList = [showList FiducialNum];
    end
end

numFiducials = length(showList)

for i = 1:numFiducials
    FiducialNum = showList(i);
    FiducialNumStr = sprintf('%d',(100 + FiducialNum));
    OriginalImageFileNameStr = sprintf('%s\\Fiducial_%s.tif',OriginalFiducialDirectory,FiducialNumStr(2:3));
    ReimageFileNameStr = sprintf('%s\\Fiducial_%s.tif',ReimageFiducialsDirectory,FiducialNumStr(2:3));
    ReimageWithCorrectionFileNameStr = sprintf('%s\\Fiducial_%s.tif',ReimageWithCorrectionFiducialsDirectory,FiducialNumStr(2:3));

    if exist(ReimageWithCorrectionFileNameStr, 'file')
        OriginalImage = imread(OriginalImageFileNameStr, 'tif');
        ReimageImage = imread(ReimageFileNameStr, 'tif');
        ReimageWithCorrectionImage = imread(ReimageWithCorrectionFileNameStr, 'tif');
        
        %apply scaling
        OriginalImage_DummyMag = 1;
        ReImagedImage_DummyMag = BestScaleFactorFromFirstFiducial;
    
        [OriginalImage_scaled, ReimageImage_scaled] = EqualizeMags(OriginalImage, OriginalImage_DummyMag, ReimageImage, ReImagedImage_DummyMag);
        [OriginalImage_scaled, ReimageWithCorrectionImage_scaled] = EqualizeMags(OriginalImage, OriginalImage_DummyMag, ReimageWithCorrectionImage, ReImagedImage_DummyMag);
        
        UncorrectedColorCombinedImage(:,:,1) = OriginalImage_scaled;
        UncorrectedColorCombinedImage(:,:,2) = ReimageImage_scaled;
        UncorrectedColorCombinedImage(:,:,3) = 0*UncorrectedColorCombinedImage(:,:,2);
        
        CorrectedColorCombinedImage(:,:,1) = OriginalImage_scaled;
        CorrectedColorCombinedImage(:,:,2) = ReimageWithCorrectionImage_scaled;
        CorrectedColorCombinedImage(:,:,3) = 0*CorrectedColorCombinedImage(:,:,2);
        
        
        subplot(2,numFiducials,FiducialNum);
        image(UncorrectedColorCombinedImage);
         axis off
        subplot(2,numFiducials,(FiducialNum)+numFiducials);
        image(CorrectedColorCombinedImage);
         axis off
    else
        break;
    end
    
    
    
end

