%fprintf('UL_R = D, UL_C = d\nLR_R = d, LR_C = d\n');
global GuiGlobalsStruct;
GuiGlobalsStruct.FontSize = 20;

%set(0,'defaulttextfontsize',20);
%set(0,'defaultaxesfontsize',20);
%set(groot, 'factoryTextFontSize', 40)

%s = settings;
%s.matlab

opts.Interpreter = 'tex';
opts.Default = 'OK';
myStr = sprintf("\\bf \\fontsize{%d}About to init Zeiss and FIBICS APIs. Press cancel to skip.", GuiGlobalsStruct.FontSize);
questdlg(myStr,'title','OK','Cancel', opts);
%questdlg('About to init Zeiss and FIBIC APIs. Press cancel to skip','title','OK','Cancel', opts);

%{
MyStr = sprintf('Create aligned target list only for WaferName?');
AnswerStr = questdlg(MyStr, 'Question', 'Just This Wafer', 'All Wafers', 'Just This Wafer');
if isempty(AnswerStr) %cancelled
    fprintf('cancelled\n');
    return; 
end

fprintf('AnsStr: %s\n', AnswerStr);
IsDoJustThisWafer = strcmp(AnswerStr, 'Just This Wafer');
fprintf('JustThiswaf: %d\n', IsDoJustThisWafer);


%NEW example 1
MyStr = sprintf('Sections will be aligned from WaferName, (WaferNameIndex), SectionNum. Press OK to proceed.');

AnswerStr = questdlg(MyStr, 'Question', 'OK', 'Cancel', 'OK');
fprintf('%s\n', AnswerStr);

if isempty(AnswerStr | strcmp(AnswerStr, 'Cancel')) %cancelled
    fprintf('cancelled\n');
    return; 
end


%}