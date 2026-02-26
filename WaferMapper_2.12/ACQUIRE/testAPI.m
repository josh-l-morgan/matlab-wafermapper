global GuiGlobalsStruct; %This is the main global that keeps track of everything

MyCZEMAPIClass = actxserver('VBComObjectWrapperForZeissAPI.KHZeissSEMWrapperComClass');
GuiGlobalsStruct.MyCZEMAPIClass = MyCZEMAPIClass;
MyReturnInt = MyCZEMAPIClass.InitialiseRemoting;
MyMag = GuiGlobalsStruct.MyCZEMAPIClass.GetMag

GuiGlobalsStruct.MyCZEMAPIClass.Fibics_Initialise();
FileName = 'C:\temp\testAPI.tif';
GuiGlobalsStruct.MyCZEMAPIClass.Fibics_AcquireImage(512,512,.2,FileName);
GuiGlobalsStruct.MyCZEMAPIClass.Fibics_WriteFOV(100); 
GuiGlobalsStruct.MyCZEMAPIClass.Fibics_IsBusy
GuiGlobalsStruct.MyCZEMAPIClass.Fibics_ReadFOV
GuiGlobalsStruct.MyCZEMAPIClass.Fibics_Cancel



