function Detection(img_sub, boundary, view_id)

global fr;
global img;
global img_path;
global img_bw_label;

close all;

img_ori_M = im2double(imread(['E:/FtpRoot/Dataset/CoreView_279_Master_Camera_08990.bmp']));
img_bkd_M = im2double(imread(['E:/FtpRoot/Dataset/bkd_279.bmp']));
img_sub  = imsubtract(img_bkd_M, img_ori_M);
img_bw = im2bw(img_sub, 0.2);
figure, imshow(img_bw);
img_bw_label = bwlabel(img_bw);
boundary = bwboundaries(img_bw);
view_id = 1;

LOW_HIGH = stretchlim(img_sub, [0.96 1]); % 0.98
img_sub = imcomplement(imadjust(img_sub, LOW_HIGH));

figure, imshow(img_sub);

%     img_sub = imresize(img_sub, 0.5);
tp_img_sub = img_sub;
options = struct('FrangiScaleRange', [1 20], 'FrangiScaleRatio', 1, 'FrangiBetaOne', 0.5, 'FrangiBetaTwo', 0.5, 'verbose',true,'BlackWhite',true);
[Ivessel, scale, dir] = FrangiFilter2D(tp_img_sub, options);
img = Ivessel / max(Ivessel(:));
figure, imshow(img);
hold on;

[img_height, img_width, img_dimension] = size(img);
if img_dimension > 1
    img = rgb2gray(img);
end

% img = im2bw(img, 0.01);
figure, imshow(img_ori_M);
hold on;
Midline_Detection_Curvilinear(boundary, view_id);



end