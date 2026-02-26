function[] = autocorrFocus()

global GuiGlobalsStruct;

sm = GuiGlobalsStruct.MyCZEMAPIClass;

tic

acFocParam.qualMode = 1;

%autofocus
acFocParam.adjustMode = 1;
autocorrFiveStep(acFocParam);

toc

%stig x
acFocParam.adjustMode = 2;
autocorrFiveStep(acFocParam);

toc
%stig y
acFocParam.adjustMode = 3;
autocorrFiveStep(acFocParam);

toc
%autofocus
acFocParam.adjustMode = 1;
autocorrFiveStep(acFocParam);
toc