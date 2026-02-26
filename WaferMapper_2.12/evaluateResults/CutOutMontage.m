


SPN = GetMyDir;
%SPN = 'Y:\Active\Merlin\Morgan Lab\MasterRaw\KxR_1A\w5\'
TPN = [SPN 'CutOutMontages\'];

if ~exist(TPN,'dir'),mkdir(TPN),end


dSPN = dir([SPN '*_Montage']);

montageNames = {dSPN.name};

cutWidth = 256;

for m = 1:length(montageNames)

    montageName = montageNames{m};
    disp(sprintf('cutting out %s. %d of %d',montageName,m,length(montageNames)))


    montageDir = [SPN montageName '\'];
    dMonDir = dir([montageDir 'Tile*.tif']);
    iNams = {dMonDir.name};

    r = zeros(length(iNams),1);
    c = zeros(length(iNams),1);


    for i  = 1:length(iNams)
        nam = iNams{i};
        und = regexp(nam,'_');
        dash = regexp(nam,'-');
        r(i) = str2num(nam(und(1)+2:dash(1)-1));
        c(i) = str2num(nam(dash(1)+2:und(2)-1));
        if i == 1;
            info = imfinfo([montageDir nam]);
        end
    end


    %% Find newest
    ind = sub2ind([max(r) max(c)],r,c);
    uInd = unique(ind);
    useInd = zeros(length(uInd),1);
    for i = 1:length(uInd)
        isInd = find(ind==uInd(i));
        if length(isInd)>1
            nL = zeros(length(isInd),1);
            for n = 1:length(isInd)
                nL(n) = length(iNams{isInd(n)});
            end
            newN = find(nL == min(nL),1);
            useInd(i) = isInd(newN);

        else
            useInd(i) = isInd;
        end
    end




    W = info.Width;
    startRead = round(W/2 - cutWidth/2);
    stopRead = startRead+cutWidth-1;


    %%Read images and make Montage of cutouts
    M = zeros(max(r)*cutWidth,max(c)*cutWidth);
    for i = 1:length(useInd)
        nam = iNams{useInd(i)};
        I = imread([montageDir nam],'pixelregion',{[startRead stopRead] [startRead stopRead]});
        pStartR = (r(useInd(i))-1) * cutWidth;
        pStartC = (c(useInd(i))-1) * cutWidth;
        M(pStartR+1:pStartR+cutWidth,pStartC+1:pStartC+cutWidth) = 256-I;
    end

    imwrite(uint8(M),[TPN montageName '.tif']);


end









