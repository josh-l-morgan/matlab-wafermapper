%clear all

utslDir = 'S:\joshm\LGNs1\UTSL_lgns1\';
montageDir = 'S:\joshm\LGNs1\rawMontages\';

%% Find all overviews

dirUTSL = dir(utslDir); dirUTSL = dirUTSL(3:end);
wafNum = 0;
for i = 1:length(dirUTSL)
    if dirUTSL(i).isdir
        nam = dirUTSL(i).name
        if lower(nam(1)) == 'w'
            soDir = [utslDir nam '\SectionOverviewsDirectory\'];
            if exist(soDir,'dir') % is there an overview directory
                dirSo = dir(soDir); dirSo = dirSo(3:end);
                soNum = [];
                wafNum = wafNum + 1;
                wafSO(wafNum).name = nam;
                
                for s = 1:length(dirSo)
                    nam = dirSo(s).name;
                    und = regexp(nam,'_');
                    dotTif = regexp(nam,'.tif');
                    if ~isempty(und) & ~isempty(dotTif)
                        secNum = str2num(nam(und(1)+1:dotTif-1));
                        if ~isempty(secNum)
                            soNum(length(soNum)+1) = secNum;
                        end
                    end %if so file
                end % run all files in so dir
                
            else  %if overview dir exists
            end % if overview dir exists
            wafSO(wafNum).soNum = soNum;
        end % if wafer
    end % if dir
end %end run dirUTSL

%% Check for tiles

for w = 1:length(wafSO)
    waf = wafSO(w).name
    for s = 1:length(wafSO(w).soNum)
        sec = wafSO(w).soNum(s);
        
        secDir = [montageDir waf '_Sec' zeroBuf(sec) '_Montage'];
         if ~exist(secDir,'dir')
            secDir = [montageDir waf '_Sec' num2str(sec) '_Montage'];
         end
        tileCount = 0;
        if exist(secDir,'dir')
            dirSec = dir(secDir); dirSec = dirSec(3:end);
            for t = 1:length(dirSec)
                nam = dirSec(t).name
                length(nam)
                if (~isempty(regexp(nam,'Tile'))) & ...
                    (~isempty(regexp(nam,'.tif'))) & ...
                    (length(nam) <30)
                tileCount = tileCount + 1;
%                 r(tileCount) = str2num(nam(7));
%                 c(tileCount) = str2num(nam(10));
                end
                
                
            end % run all tiles
            
        end %if there is a section dir
        wafSO(w).sec(s) = sec;
        wafSO(w).tileCount(s) = tileCount;

    end % run all sections
    
end % run all wafers

%% Display Results
fsize = 200;
field = zeros(length(wafSO),fsize,3,'uint8');
for w = 1:length(wafSO)
    sec = wafSO(w).sec;
    fieldInds = sub2ind(size(field),w*ones(length(sec),1),sec',3*ones(length(sec),1))
    field(fieldInds) = 250;
    fieldInds = sub2ind(size(field),w*ones(length(sec),1),sec',2*ones(length(sec),1))
    fieldInds = fieldInds(wafSO(w).tileCount == 16);
    field(fieldInds) = 255;

     fieldInds = sub2ind(size(field),w*ones(length(sec),1),sec',1*ones(length(sec),1))
    fieldInds = fieldInds(wafSO(w).tileCount >1);
    field(fieldInds) = 255;
end
image(field)




