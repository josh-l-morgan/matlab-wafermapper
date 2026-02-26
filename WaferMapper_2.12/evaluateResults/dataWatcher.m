

waferName = 'waf002'

SPN = 'F:\Joshm\ixQ\ixQ_waf002_IL_10nm_8x_v1\'
TPN = 'F:\Joshm\ixQ\ixQ_waf001_IL_10nm_8x_v1\'
bookDir = [SPN 'LogBooks\'];
%gDrive = 'C:\Users\View192\Google Drive\logBooks\'

bookName = ['LogBook_' waferName];
%%
while 1

%% Summarize logBook and write to excel    
%logSec2Excel(bookDir, bookName);

%% Copy logBook to google drive
success = 1;
while ~success
    [success message] = copyfile([bookDir bookName '.mat'],[gDrive bookName '.mat'])
    pause(.1)
end
pause(3)

success = 1;
while ~success
    [success message] = copyfile([bookDir bookName '.xls'],[gDrive bookName '.xls'])
    pause(.1)
end

%% collect quality images
checkWaferQuality(SPN,TPN,waferName)
%checkWaferStitching(SPN,TPN,waferName)


pause(5)
end
