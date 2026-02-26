function [curvature] = curvature1(points)
%curvature value of each point
curvature=zeros(size(points,1),1);
for i=1:size(points,1)
    x=points(i,1);
    y=points(i,2);
    dx  = gradient(x);
    ddx = gradient(dx);
    dy  = gradient(y);
    ddy = gradient(dy);
    num   = dx .* ddy - ddx .* dy;
    denom = dx .* dx + dy .* dy;
    denom = sqrt(denom);
    denom = denom * denom * denom;
    curvature(i) = num ./ denom;
%     if denom < 0
%         curvature(i) = NaN;
end
end


