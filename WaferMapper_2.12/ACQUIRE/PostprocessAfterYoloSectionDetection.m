function [OriginalSectionPoints] = PostprocessAfterYoloSectionDetection(OriginalSectionPoints)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
global GuiGlobalsStruct;
temp = GuiGlobalsStruct.FullMapImage;
e = edge(temp, 'canny', [], 1);
sz = size(temp);
[val,~] = min(sz);
radii = round(val/2):1:val;
h = circle_hough(e, radii, 'same', 'normalise');
peaks = circle_houghpeaks(h, radii, 'npeaks', 5);
[val,idx] = max(peaks(3,:));
points = circle_inside_points(temp, val, peaks(1,idx), peaks(2,idx));
[~,idxs] = ismember(points,OriginalSectionPoints);
OriginalSectionPoints(idxs) = [];
end