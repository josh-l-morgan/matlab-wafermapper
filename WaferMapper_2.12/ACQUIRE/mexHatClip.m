function[Imf] = mexHatClip(I,s1,s2);

%% set defaults
if ~exist('s1','var')
    s1 = 5;
    s2 = 6;
    
end
if ~exist('s2','var')
    s2 = s1+1;
end

%%
kSize = [s2 * 4 s2 * 4];

kRad = (kSize )/2;
kern = zeros(kSize);

[y x z] = ind2sub(kSize,find(kern==0));
dists = sqrt(((y-kRad(1))).^2 + ((x - kRad(2))).^2);

cKern = 1 * exp(-.5 * (dists/s1).^2);
cKern = cKern/sum(cKern(:));
sKern = 1 * exp(-.5 * (dists/s2).^2);
sKern = sKern/sum(sKern(:));
kern(:) = (cKern ) - sKern;

% subplot(2,1,1)
% plot(kern(round(kRad(1)),:))

%% resize I
fillVal = median(double(I(:)));
meanVal = mean(double(I(:)));
Itemp = zeros(size(I,1)+kRad(1)*2,size(I,2) + kRad(2)*2)+fillVal;
Itemp(kRad(1)+1:kRad(1)+size(I,1),kRad(2)+1:kRad(2)+size(I,2)) = double(I);


%%Convolve

Itemp = fastCon(Itemp,kern);
Imf = Itemp(kRad(1)+1:kRad(1)+size(I,1),kRad(2)+1:kRad(2)+size(I,2));
imf = Imf(kSize(1)+1:end-kSize(1),kSize(2)+1:end-kSize(2));
Imf =Imf-min(Imf(:));
Imf = Imf * 255/max(Imf(:));
if 0
    h = figure;
    a = gca(h);
    imshow(uint8(Imf),'Parent',a);
    pause(2)
    close(h)
end
%Itemp = Itemp-min(Itemp(:));
%pixClip = min(kSize,round(size(I,1)/3));
%Imf  = Itemp * 0;
%Imf(pixClip +1:end-pixClip,pixClip +1:end-pixClip)=Itemp(pixClip +1:end-pixClip,pixClip +1:end-pixClip);
%Imf(Imf<0)=0;
%Imf = Imf*256/max(Imf(:));
