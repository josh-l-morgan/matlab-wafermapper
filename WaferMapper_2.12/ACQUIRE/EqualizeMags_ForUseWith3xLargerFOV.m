function [Image1_scaled, Image2_scaled] = EqualizeMags_ForUseWith3xLargerFOV(Image1_x3LargerROI, Image2, ScalingFactorForImage2RelativeToImage1)

sc = 1/ScalingFactorForImage2RelativeToImage1;
I = Image1_x3LargerROI;
[ys1 xs1] = size(I);
I = imresize(I,sc);
[ys2 xs2] = size(I);

dify = ys2 - ys1;
difx = xs2 - xs1;
if dify>=0;
    I2 = I(round(dify/2)+1:round(dify/2)+ys1, round(difx/2)+1:round(difx/2)+xs1);
% Karl changed the "<" to a "<="
elseif dify<0
    aby = abs(dify);
    abx = abs(difx);
    I2 = zeros(ys1,xs1,class(I))+median(I(:));
    I2(round(aby/2)+1:round(aby/2)+ys2, round(abx/2)+1:round(abx/2)+xs2) = I;
end

Image1_scaled = I2;
Image2_scaled = Image2;
