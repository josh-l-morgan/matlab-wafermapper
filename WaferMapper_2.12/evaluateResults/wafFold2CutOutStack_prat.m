clear all
SPN = 'F:\Joshm\jxQ\really_high_res\stack3\'
stackName = [SPN(1:end-1) '_center_cutouts\'];
if ~exist(stackName,'dir'),mkdir(stackName);end

dSPN = dir(SPN);

c = 0;
clear sec fold;
for i = 7:length(dSPN); %length(dSPN)
    nam = dSPN(i).name;
    s = regexp(nam,'_Sec');
    m = regexp(nam,'_Mon');
   if ~isempty(s) & ~isempty(m)
        c = c+1;
       sec(c) = str2num(nam(s(1)+4:m(1)-1));
       fold{c} = nam;
   end
end


c = 0;
for i = 1:length(fold)
    dMon = dir([SPN fold{i} '\*.tif']);
    for m = 1:length(dMon);
        nam = dMon(m).name;
        t =  regexp(nam,'.tif');
        
        if ~isempty(t)
            c = c+ 1;
            imnam{c} = nam;
            imfold{c} = fold{i};
        end
    
    end
end


info = imfinfo([SPN imfold{1} '\' imnam{4}]);
xs = info.Width; ys = info.Height;
cutSize = 1024;
centX = 10000%round(xs/2-cutSize/2);
centY = 10000%round(ys/2-cutSize/2);
disp(length(imnam));
for i = 900:length(imnam)
    m = 0;
    l = 0;
    m = strfind(imnam{i},'2020');
    l = strfind(imnam{i},'Stitched');
    if ~isempty(m) | ~isempty(l) 
        continue
    end
    oldName = [SPN imfold{i} '\' imnam{i}];
    newName = [stackName imnam{i}];
    I = imread(oldName,'pixelregion',{[centY+1, centY + cutSize],[1,xs]});
    Ic = I(:,centX+1:centX+cutSize);
    disp(newName);
    disp(i);

    imwrite(Ic,newName);
    %copyfile(oldName,newName)
    
end



