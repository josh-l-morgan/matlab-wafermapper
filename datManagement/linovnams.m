SPN = 'X:\MasterUTSL\hxH\trakEM_test\allOverviews\';
TPN = 'X:\MasterUTSL\hxH\trakEM_test\allOverviews_lind\';
if ~exist(TPN,'dir'), mkdir(TPN); end

dSPN = dir([SPN '*.tif']);

nams = {dSPN(:).name};


for i = 1:length(nams)
    
   nam = nams{i};
   wa = regexp(nam,'waf');
   und = regexp(nam,'_');
   tf = regexp(nam,'.tif');
   ov = regexp(nam,'w_');
   w(i) = str2num(nam(wa(end)+3:und(1)-1));
   s(i) = str2num(nam(ov(1)+2:tf(1)-1));
    
end

ind = w*1000+s;

[a ord] = sort(ind,'ascend');

nams = nams(ord);
w = w(ord);
s = s(ord);

for i = 1:length(nams)
    
    
    nam = nams{i};
   newNam = sprintf('ind%06.0f_%s',i,nam);
   copyfile([SPN nam],[TPN newNam]);
    
end



%% resample 10

for i = 1:length(nams)
    i
    if w(i) == 10
        nam = nams{i};
        newNam = sprintf('ind%06.0f_%s',i,nam);
        
        I = imread([SPN nam]);
        Ir = imresize(I,2/3);
        In = I * 0 + mode(I(:));
        [y x] = size(I);
        [Y X] = size(Ir);
        sY = floor((y-Y)/2);
        sX = floor((x-X)/2);
        
        In(sY +1:sY+Y, sX+1:sX+X) = Ir;
        %    image(In)
        %    colormap gray(256)
        %
        imwrite(In, [TPN newNam])
    end
    
end



