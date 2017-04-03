function contour1 = resample_equal(contour,n)
%对轮廓上的点重新等间隔采样
%n-采样点的个数
tmp = [contour(2:end,:); contour(1,:)];
dist = sqrt(sum((tmp-contour).^2,2));%相邻点之间的距离
a = zeros(size(dist));
x = zeros(size(dist));
y = zeros(size(dist));
x(1) = contour(1,1);
y(1) = contour(1,2);
for j = 2:length(dist)
    a(j) = a(j-1) + dist(j-1);
    x(j) = contour(j,1);
    y(j) = contour(j,2);
end
[b idx] = unique(a);
a = b;
x = x(idx);
y = y(idx);
a1 = 0:a(end)/n:a(end);
x1 = interp1(a,x,a1);
y1 = interp1(a,y,a1);
% plot(contour(:,1),contour(:,2),'.')
% axis equal;
% hold on;
% plot(x1,y1,'r+');
% hold on;
% plot(x1,y1,'r');
contour1 = [x1' y1'];