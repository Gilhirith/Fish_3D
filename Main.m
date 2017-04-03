close all;
clear all;
clc;
% %====================CALCULATE/SET global para====================% %
%--------------------global para--------------------%
global nseg;
global meas;
global img_path;
global img_ori;
global img_bkd;
global bg_frame;
global ed_frame;
global delta_frame;
global img_height;
global img_width;
global fr;
global min_midline_len;
global avg_head_width;
global CNN_sample_ht;
global CNN_sample_wd;
global img_bw_label;
global Cam_Para;
global F_matrix;
global img_sub_M;
global nfish;

%--------------------add path--------------------%
% addpath('../Fish_3D/CoreView258/');
% img_path = '../Fish_3D/CoreView258/';
% bkd_img_name_M = 'bkd_27_Stone.bmp';
% bkd_img_name_M = '../Dataset/bkd_241.bmp';
bkd_img_name_S1 = 'bkd_213_S1.bmp';
bkd_img_name_S2 = 'bkd_213_S2.bmp';

% figure, imshow(imread('bkd_217_S1.bmp'));
% figure, imshow(imread('bkd_213_S1.bmp'));
% figure, imshow(imread('bkd_212_S1.bmp'));
% figure, imshow(imread('bkd_217_S2.bmp'));
% figure, imshow(imread('bkd_213_S2.bmp'));
% figure, imshow(imread('bkd_212_S2.bmp'));

% % %--------------------calculate background--------------------%
% cnt1 = 0;
% cnt2 = 0;
% cnt3 = 0;
% for i = 4500 : 7500
%     i
%     tic;
% %     I = imread(['../Fish_3D/CoreView258/CoreView_258_Master_Camera_', sprintf('%04d', i), '.bmp']);
% %     imwrite(I, ['./CoreView258_jpg_/', 'CoreView_258_M_', sprintf('%04d', i), '.jpg']);
%     I = imread(['E:/FtpRoot/Dataset/CoreView_213/', 'CoreView_213_Master_Camera_', sprintf('%05d', i), '.bmp']);
%     cnt1 = cnt1 + im2double(I);
%     I = imread(['E:/FtpRoot/Dataset/CoreView_213/', 'CoreView_213_Slave1_Camera_', sprintf('%05d', i), '.bmp']);
%     cnt2 = cnt2 + im2double(I);
%     I = imread(['E:/FtpRoot/Dataset/CoreView_213/', 'CoreView_213_Slave2_Camera_', sprintf('%05d', i), '.bmp']);
%     cnt3 = cnt3 + im2double(I);
%     toc;
% end
% 
% img_bg1 = cnt1 / 3001;
% imwrite(img_bg1, 'bkd_213_M.bmp'); % (2)
% img_bg2 = cnt2 / 3001;
% imwrite(img_bg2, 'bkd_213_S1.bmp'); % (3)
% img_bg3 = cnt3 / 3001;
% imwrite(img_bg3, 'bkd_213_S2.bmp');

%--------------------general para--------------------%
bg_frame = 4500;%12890; 720
ed_frame = 6499;%15926;
delta_frame = 1;
%--------------------fish model para--------------------%
nseg = 8;
avg_head_width = 18; % half
CNN_sample_ht = 48;
CNN_sample_wd = 48;
nfish = 20;
%--------------------stereo para--------------------%

%--------------------detection para--------------------%
min_midline_len = 60;

%--------------------tracking para--------------------%

% %====================Detection====================% %
%--------------------perform detection--------------------%
% tic;
for fr = bg_frame : delta_frame : ed_frame
    fr
% %     tic;
% %     % detection of Master View ---FINAL
% %     img_ori_M = im2double(imread(['E:/FtpRoot/Dataset/CoreView_213/', 'CoreView_213_Master_Camera_', sprintf('%05d', fr), '.bmp']));
% % %     img_ori_M = im2double(imread(['E:/FtpRoot/Dataset/20160617/27_Stone/', 'CoreView_340_Flare_4M180_NCL_(2)_', sprintf('%05d', fr), '.bmp']));
% %     img_bkd_M = im2double(imread(bkd_img_name_M));
% %     img_sub_M = imsubtract(img_bkd_M, img_ori_M);
% % %     figure, imshow(img_sub_M);
% % %     img_sub_M = img_sub_M - min(img_sub_M(:));
% %     img_sort = sort(img_sub_M(:), 'descend');
% %     fish_val = img_sort(nfish * 3000);
% %     img_sub_M(find(img_sub_M < fish_val)) = 0;
% % %     figure, imshow(img_sub_M);
% % %     img_sub_M = imadjust(img_sub_M, [], []);
% % %     figure, imshow(img_sub_M);
% % %     img_sub_M(find(img_sub_M < 0.48)) = 0;
% % %     img_sub_M = imadjust(img_sub_M);
% %     [img_height, img_width] = size(img_ori_M);
% % %     img_bw = im2bw(img_sub_M, 0.1); 
% % %     figure, imshow(img_sub_M);
% % %     hold on;
% %     points = Master_Head_Detection();
% %     saveas(gcf, ['res_340/CV340_M_detection_res_', num2str(fr), '.jpg']);
% %     close all;
% %     % END detection of Master View ---FINAL
% %     toc;
    
    % detection of Slave1 View
    tic;
    img_ori_S1 = im2double(imread(['E:/FtpRoot/Dataset/CoreView_213/', 'CoreView_213_Slave1_Camera_', sprintf('%05d', fr), '.bmp']));
    img_bkd_S1 = im2double(imread(bkd_img_name_S1));
    img_sub_S1 = imsubtract(img_bkd_S1, img_ori_S1);
    [img_height, img_width] = size(img_ori_S1);
    
    img_sub_S1(find(img_sub_S1 < 0)) = 0;
%     figure, imshow(img_sub_S1);
    img_sub_S1 = imfill(img_sub_S1);
    figure, imshow(img_sub_S1);
    hold on;
    
    F = img_sub_S1;
    level = graythresh(F);
    BW1 = im2bw(F, level);
%     figure, imshow(BW1);
    [fx, fy] = gradient(F);
    f = sqrt(fx.^2 + fy.^2);
    f = f / max(f(:));
    level = graythresh(f);
    BW = im2bw(f, 0.08);
%     figure, imshow(BW);
    f = double(BW) + double(BW1);
    f(find(f>1)) = 1;
%     figure, imshow(f);
    bw_f = im2bw(f, 0.5);
%     figure, imshow(bw_f);
    img_bw_label = bwlabel(bw_f);
    stats = regionprops(bw_f, 'Area');
    areas = [stats.Area];
    idx_areas = find(areas > 500);
    img_bw = ismember(img_bw_label, idx_areas);
%     figure, imshow(img_bw);
    img_bw_2 = imfill(img_bw, 'holes');
    figure, imshow(img_bw_2);
    boundary = bwboundaries(img_bw_2);
%     plot(boundary1(:,2), boundary1(:,1), 'g', 'LineWidth', 1);
    img_bw_label = bwlabel(img_bw_2);
    hold on;
    meas{fr}.view{2}.img_bw = img_bw_2;
    Detection(img_sub_S1, boundary, 2);
%     saveas(gcf, ['res_213/CV338_M_detection_res_', num2str(fr), '.jpg']);
    close all;
%     toc;
    
%     % detection of Slave2 View
%     tic;
%     img_ori_S2 = im2double(imread(['E:/FtpRoot/Dataset/20160617/11_Stone/', 'CoreView_338_Flare_4M180_NCL_(2)_', sprintf('%05d', fr), '.bmp']));
%     img_bkd_S2 = im2double(imread(bkd_img_name_S2));
%     img_sub_S2 = imsubtract(img_bkd_S2, img_ori_S2);
%     [img_height, img_width] = size(img_ori_S2);
%     
%     img_sub_S2(find(img_sub_S2 < 0)) = 0;
% %     figure, imshow(img_sub_M);
%     img_sub_S2 = imfill(img_sub_S2);
%     figure, imshow(img_sub_S2);
%     hold on;
%     
%     F = img_sub_S2;
%     level = graythresh(F);
%     BW1 = im2bw(F, level);
% %     figure, imshow(BW1);
%     [fx, fy] = gradient(F);
%     f = sqrt(fx.^2 + fy.^2);
%     f = f / max(f(:));
%     level = graythresh(f);
%     BW = im2bw(f, 0.08);
% %     figure, imshow(BW);
%     f = double(BW) + double(BW1);
%     f(find(f>1)) = 1;
% %     figure, imshow(f);
%     bw_f = im2bw(f, 0.5);
% %     figure, imshow(bw_f);
%     img_bw_label = bwlabel(bw_f);
%     stats = regionprops(bw_f, 'Area');
%     areas = [stats.Area];
%     idx_areas = find(areas > 500);
%     img_bw = ismember(img_bw_label, idx_areas);
% %     figure, imshow(img_bw);
%     img_bw_2 = imfill(img_bw, 'holes');
% %     figure, imshow(img_bw_2);
%     boundary = bwboundaries(img_bw_2);
% %     plot(boundary1(:,2), boundary1(:,1), 'g', 'LineWidth', 1);
%     img_bw_label = bwlabel(img_bw_2);
% %     hold on;
%     meas{fr}.view{3}.img_bw = img_bw_2;
%     Detection(img_sub_S2, boundary, 3);
%     saveas(gcf, ['res_213/CV213_S2_detection_res_', num2str(fr), '.jpg']);
%     close all;
%     toc;
    
%     if mod(fr, 500) == 0
%         save(['meas_cv338_DoH_M_9550', '-', num2str(fr), '_step1.mat'], 'meas', '-v7.3');
%     end
    
% %     % detection of Slaver1 View
% %     img_ori_S1 = im2double(imread(['E:/FtpRoot/Dataset/CoreView_217/', 'CoreView_217_Slave1_Camera_', sprintf('%05d', fr), '.bmp']));
% %     img_bkd_S1 = im2double(imread(bkd_img_name_S1));
% %     img_sub_S1 = imsubtract(img_bkd_S1, img_ori_S1);
% %     [img_height, img_width] = size(img_ori_S1);
% % %     figure, imshow(imcomplement(img_sub_S1));
% %     F = img_sub_S1;
% %     
% %     level = graythresh(F);
% %     BW1 = im2bw(F, level);
% % %     figure, imshow(BW1);
% %         
% %     [fx, fy] = gradient(F);
% %     f = sqrt(fx.^2 + fy.^2);
% %     f = f / max(f(:));
% %     level = graythresh(f);
% %     BW = im2bw(f, 0.08);
% % %     figure, imshow(BW);
% %     f = double(BW) + double(BW1);
% %     f(find(f>1)) = 1;
% % %     figure, imshow(f);
% %     bw_f = im2bw(f, 0.5);
% % %     figure, imshow(bw_f);
% %     img_bw_label = bwlabel(bw_f);
% %     stats = regionprops(bw_f, 'Area');
% %     areas = [stats.Area];
% %     idx_areas = find(areas > 500);
% %     img_bw = ismember(img_bw_label, idx_areas);
% % %     figure, imshow(img_bw);
% %     img_bw_2 = imfill(img_bw, 'holes');
% %     boundary = bwboundaries(img_bw_2);
% % %     figure, imshow(img_bw_2);
% %     Detection(img_sub_M, boundary, 2);
% %     imwrite(img_bw_2, ['./segmentation_res_S1/', 'CV_212_segmentation_S1_', sprintf('%05d', fr), '.bmp']);
% %     
% %     % detection of Slaver2 View
% %     img_ori_S2 = im2double(imread(['E:/FtpRoot/Dataset/CoreView212/', 'CoreView_212_Slave2_Camera_', sprintf('%05d', fr), '.bmp']));
% %     img_bkd_S2 = im2double(imread(bkd_img_name_S2));
% %     img_sub_S2 = imsubtract(img_bkd_S2, img_ori_S2);
% %     [img_height, img_width] = size(img_ori_S2);
% % %     figure, imshow(imcomplement(img_sub_S2));
% %     F = img_sub_S2;
% %     
% %     level = graythresh(F);
% %     BW1 = im2bw(F, level);
% % %     figure, imshow(BW1);
% %         
% %     [fx, fy] = gradient(F);
% %     f = sqrt(fx.^2 + fy.^2);
% %     f = f / max(f(:));
% %     level = graythresh(f);
% %     BW = im2bw(f, 0.08);
% % %     figure, imshow(BW);
% %     f = double(BW) + double(BW1);
% %     f(find(f>1)) = 1;
% % %     figure, imshow(f);
% %     bw_f = im2bw(f, 0.5);
% % %     figure, imshow(bw_f);
% %     img_bw_label = bwlabel(bw_f);
% %     stats = regionprops(bw_f, 'Area');
% %     areas = [stats.Area];
% %     idx_areas = find(areas > 200);
% %     img_bw = ismember(img_bw_label, idx_areas);
% %     figure, imshow(img_bw);
% %     img_bw_2 = imfill(img_bw, 'holes');
% % %     figure, imshow(img_bw_2);
% %     imwrite(img_bw_2, ['./segmentation_res_S2/', 'CV_212_segmentation_S2_', sprintf('%05d', fr), '.bmp']);
    
%     hold on;
%     Detection(img_sub_M);
%     saveas(gcf, ['res_5/detection_res_', num2str(fr), '.jpg']);
%     close all;
%     toc;
end
save(['meas_cv340_DoH_M_1', '-', num2str(559), '_step1.mat'], 'meas', '-v7.3');
tic;

% save(['meas_blobXmidlineXnose_cv217_M_325', '-', num2str(fr), '_Midline_step1.mat'], 'meas', '-v7.3');

% save('meas_cv258_1-5815_combine_step1.mat', 'meas', '-v7.3');
%--------------------read detection data--------------------%

% %====================Tracking====================% %
% Tracking();
% %====================SAVE results====================% %

