function[] = focusStigFiveStep




%% AutoFocus
acFocParam.adjustMode = 1;
acFocParam.minCheckRange = .5/1000000;
acFocParam.reps = 20; %defalt is no minimum adjustment
acFocParam.qualMode = 2; %defalt qual mode is variance
acFocParam.minQualRange = 0.0005; %defalt qual mode is variance


autocorrFiveStep(acFocParam)
%acFocParam.ck5;


%% AutoStig

for s = 1:4
    
    %% AutoStig X
    if exist('ckX')
        acFocParam.ck5 = ckX;
    end
    acFocParam.adjustMode = 2;
    acFocParam.minCheckRange = 0.01;
    acFocParam.reps = 5; %defalt is no minimum adjustment
    acFocParam.qualMode = 2; %defalt qual mode is variance
    acFocParam.minQualRange = 0.0005; %defalt qual mode is variance
    
    
    ckX = autocorrFiveStep(acFocParam)
    %acFocParam.ck5;
    
    
    
    
    %% AutoStig Y
    if exist('ckY')
        acFocParam.ck5 = ckY;
    end
    acFocParam.adjustMode = 3;
    acFocParam.minCheckRange = 0.01;
    acFocParam.reps = 5; %defalt is no minimum adjustment
    acFocParam.qualMode = 2; %defalt qual mode is variance
    acFocParam.minQualRange = 0.0005; %defalt qual mode is variance
    
    
    ckY = autocorrFiveStep(acFocParam)
    %acFocParam.ck5;
    
end




%% AutoFocus
acFocParam.adjustMode = 1;
acFocParam.minCheckRange = .5/1000000;
acFocParam.reps = 20; %defalt is no minimum adjustment
acFocParam.qualMode = 2; %defalt qual mode is variance
acFocParam.minQualRange = 0.0005; %defalt qual mode is variance


autocorrFiveStep(acFocParam)
%acFocParam.ck5;



