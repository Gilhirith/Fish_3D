function Image_Binarization()

global fr;
global img_ori_M;
global img_bkd_M;
global img_sub_M;
global img_bw_M;
global img_ori_S1;
global img_bkd_S1;
global img_sub_S1;
global img_bw_S1;
global img_ori_S2;
global img_bkd_S2;
global img_sub_S2;
global img_bw_S2;


[img_height, img_width] = size(img_ori_M);

img_sub_M(find(img_sub_M < 0)) = 0;
% figure, imshow(img_sub_M);
img_sub_M = imfill(img_sub_M);
% figure, imshow(img_sub_M);
% hold on;

F = img_sub_M;
level = graythresh(F);
BW1 = im2bw(F, level);
% figure, imshow(BW1);
[fx, fy] = gradient(F);
f = sqrt(fx.^2 + fy.^2);
f = f / max(f(:));
level = graythresh(f);
BW = im2bw(f, 0.08);
% figure, imshow(BW);
f = double(BW) + double(BW1);
f(find(f>1)) = 1;
% figure, imshow(f);
bw_f = im2bw(f, 0.5);
% figure, imshow(bw_f);
img_bw_label = bwlabel(bw_f);
stats = regionprops(bw_f, 'Area');
areas = [stats.Area];
idx_areas = find(areas > 500);
img_bw = ismember(img_bw_label, idx_areas);
% figure, imshow(img_bw);
img_bw_M = imfill(img_bw, 'holes');
% figure, imshow(img_bw_M);



img_sub_S1(find(img_sub_S1 < 0)) = 0;
% figure, imshow(img_sub_S1);
img_sub_S1 = imfill(img_sub_S1);
% figure, imshow(img_sub_S1);
% hold on;

F = img_sub_S1;
level = graythresh(F);
BW1 = im2bw(F, level);
% figure, imshow(BW1);
[fx, fy] = gradient(F);
f = sqrt(fx.^2 + fy.^2);
f = f / max(f(:));
level = graythresh(f);
BW = im2bw(f, 0.08);
% figure, imshow(BW);
f = double(BW) + double(BW1);
f(find(f>1)) = 1;
% figure, imshow(f);
bw_f = im2bw(f, 0.5);
% figure, imshow(bw_f);
img_bw_label = bwlabel(bw_f);
stats = regionprops(bw_f, 'Area');
areas = [stats.Area];
idx_areas = find(areas > 500);
img_bw = ismember(img_bw_label, idx_areas);
% figure, imshow(img_bw);
img_bw_S1 = imfill(img_bw, 'holes');
% figure, imshow(img_bw_S1);



img_sub_S2(find(img_sub_S2 < 0)) = 0;
% figure, imshow(img_sub_S2);
img_sub_S2 = imfill(img_sub_S2);
% figure, imshow(img_sub_S2);
% hold on;

F = img_sub_S2;
level = graythresh(F);
BW1 = im2bw(F, level);
% figure, imshow(BW1);
[fx, fy] = gradient(F);
f = sqrt(fx.^2 + fy.^2);
f = f / max(f(:));
level = graythresh(f);
BW = im2bw(f, 0.08);
% figure, imshow(BW);
f = double(BW) + double(BW1);
f(find(f>1)) = 1;
% figure, imshow(f);
bw_f = im2bw(f, 0.5);
% figure, imshow(bw_f);
img_bw_label = bwlabel(bw_f);
stats = regionprops(bw_f, 'Area');
areas = [stats.Area];
idx_areas = find(areas > 500);
img_bw = ismember(img_bw_label, idx_areas);
% figure, imshow(img_bw);
img_bw_S2 = imfill(img_bw, 'holes');
% figure, imshow(img_bw_S2);
