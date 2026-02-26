function [points] = circle_inside_points(im, r, cx, cy)
%return the inside pixels of the circle with the r as the radius and the [cx,cy] as
%the center point.
sz = size(im);
points = [];
mask = zeros(sz);
for i=1:sz(1)
    for j=1:sz(2)
        if (i-cx)^2+(j-cy)^2<=r^2
            points(end+1,1) = i;
            points(end,2) = j;
        end
    end
end
end