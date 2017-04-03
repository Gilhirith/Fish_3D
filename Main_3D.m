close all;
% clear all;
clc;

% %====================CALCULATE/SET global para====================% %
%--------------------global paras--------------------%
global nseg;
global meas;
global nfish;
global img_path;
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
global img_ori_M img_bkd_M img_sub_M;
global img_ori_S1 img_bkd_S1 img_sub_S1;
global img_ori_S2 img_bkd_S2 img_sub_S2;
global thr_matching_dis_line_to_blob;
global thr_matching_dis_blob_to_blob;
global trajs_3d;
global trajs; % 2d traj in Master View
global match_idx_s1;
global match_idx_s2;
global F_matrix;
global thr_vel_2d;
global img_adj;
global trained_LSTM_mat;
global problem_motion mones mzeros convert usegpu signum;

%--------------------global para value--------------------%
%----------------general para----------------%
bg_frame = 2122;%12890; 325; 4500
ed_frame = 4121;%15926; 865; 6499
delta_frame = 1;

%----------------fish model para----------------%
nseg = 8;
nfish = 10;
avg_head_width = 18; % half
CNN_sample_ht = 48;
CNN_sample_wd = 48;

%----------------stereo para----------------%
Cal_Camera_Para();
thr_matching_dis_line_to_blob = 20;
thr_matching_dis_blob_to_blob = 30;

%----------------detection para----------------%
min_midline_len = 60;

%----------------LSTM para----------------%
trained_LSTM_mat = 'LSTM_train_motion_delta_vel_0510.mat';

%----------------tracking para----------------%
thr_vel_2d = 50;

% %====================add path====================% %
% addpath(genpath('../')); % low efficiency
% addpath(genpath('D:/Uriel/TOOLBOX_calib/'));
addpath(genpath('./LSTM-MATLAB-master/'));
img_path = 'E:/FtpRoot/Dataset/CoreView_217/';
bkd_img_name_M = 'bkd_217_M.bmp';
bkd_img_name_S1 = 'bkd_217_S1.bmp';
bkd_img_name_S2 = 'bkd_217_S2.bmp';

% % %====================calculate background (if needed)====================% %
% cnt1 = 0;
% cnt2 = 0;
% cnt3 = 0;
% for i = 1 : 11801
%     i
% %     tic;
% %     I = imread(['../Fish_3D/CoreView258/CoreView_258_Master_Camera_', sprintf('%04d', i), '.bmp']);
% %     imwrite(I, ['./CoreView258_jpg_/', 'CoreView_258_M_', sprintf('%04d', i), '.jpg']);
%     I = imread(['E:/FtpRoot/Dataset/20160617/27_Stone/', 'CoreView_340_Flare_4M180_NCL_(2)_', sprintf('%05d', i), '.bmp']);
%     cnt1 = cnt1 + im2double(I);
% %     I = imread(['E:/FtpRoot/Dataset/CoreView_217/', 'CoreView_217_Slave1_Camera_', sprintf('%05d', i), '.bmp']);
% %     cnt2 = cnt2 + im2double(I);
% %     I = imread(['E:/FtpRoot/Dataset/CoreView_217/', 'CoreView_217_Slave2_Camera_', sprintf('%05d', i), '.bmp']);
% %     cnt3 = cnt3 + im2double(I);
% %     toc;
% end
% 
% img_bg1 = cnt1 / 11801;
% imwrite(img_bg1, 'bkd_27_Stone.bmp');
% % img_bg2 = cnt2 / 5000;
% % imwrite(img_bg2, 'bkd_217_S1.bmp');
% % img_bg3 = cnt3 / 5000;
% % imwrite(img_bg3, 'bkd_217_S2.bmp');

% % %====================Train LSTM (if needed)====================% %
% load connected_head_3d_trajs_cv217_325-865_Single_Side_View3
% tic;
% Training_LSTM();
% toc;

%--------------------load trained LSTM--------------------%
load(trained_LSTM_mat);

% % %====================Detection (if needed)====================% %
% %--------------------perform detection--------------------%
% tic;
% for fr = bg_frame : delta_frame : ed_frame
%     fr
%     tic;
%     % detection of Master View
% % %     img_ori_M = im2double(imread(['E:/FtpRoot/Dataset/CoreView_217/', 'CoreView_217_Master_Camera_', sprintf('%05d', fr), '.bmp']));
% % %     img_bkd_M = im2double(imread(bkd_img_name_M));
% % %     img_sub_M = imsubtract(img_bkd_M, img_ori_M);
% % %     [img_height, img_width] = size(img_ori_M);
% % %     img_bw = im2bw(img_sub_M, 0.1); 
% % %     figure, imshow(img_ori_M);
% % %     hold on;
% % %     points = Master_Head_Detection();
% % %     saveas(gcf, ['res_10/detection_res_', num2str(fr), '.jpg']);
% % %     close all;
% % %     toc;
% % %     if mod(fr - 60, 1000) == 0
% % %         save(['meas_cv258_M_61', '-', num2str(fr), '_DoH_step1.mat'], 'meas', '-v7.3');
% % %     end
% 
% % %     img_ori_M = im2double(imread(['E:/FtpRoot/Dataset/CoreView_213/', 'CoreView_213_Master_Camera_', sprintf('%05d', fr), '.bmp']));
% % %     img_bkd_M = im2double(imread(bkd_img_name_M));
% % %     img_sub_M = imsubtract(img_bkd_M, img_ori_M);
% % %     [img_height, img_width] = size(img_ori_M);
% % %     img_bw = im2bw(img_sub_M, 0.1); 
% % % %     figure, imshow(img_sub_M);
% % %     img_adj = imadjust(img_sub_M, [0, 0.6], [0, 1]);
% % %     figure, imshow(img_ori_M);
% % %     hold on;
% % %     points = Master_Head_Detection();
% % %     saveas(gcf, ['res_213_M/detection_res_', num2str(fr), '.jpg']);
% % %     close all;
% % %     toc;
% % %     if mod(fr, 1000) == 0
% % %         save(['meas_cv311_M_1', '-', num2str(fr), '_DoH_step1.mat'], 'meas', '-v7.3');
% % %     end
% 
% % % % 
% % % %     % detection of Slaver1 View
% % % %     
% % % %     img_ori_S1 = im2double(imread(['E:/FtpRoot/Dataset/CoreView_217/', 'CoreView_217_Slave1_Camera_', sprintf('%05d', fr), '.bmp']));
% % % %     img_ori_S2 = im2double(imread(['E:/FtpRoot/Dataset/CoreView_217/', 'CoreView_217_Slave2_Camera_', sprintf('%05d', fr), '.bmp']));
% % % % 
% % % % %     img_ori_S1 = im2double(imread(['E:/FtpRoot/Dataset/CoreView212/', 'CoreView_212_Slave1_Camera_', sprintf('%05d', fr), '.bmp']));
% % % % %     img_ori_S2 = im2double(imread(['E:/FtpRoot/Dataset/CoreView212/', 'CoreView_212_Slave2_Camera_', sprintf('%05d', fr), '.bmp']));
% % % % 
% % % % %     Data_Association(points);
% % % %     
% % % %     img_bkd_S1 = im2double(imread(bkd_img_name_S1));
% % % %     img_sub_S1 = imsubtract(img_bkd_S1, img_ori_S1);
% % % %     [img_height, img_width] = size(img_ori_S1);
% % % % %     figure, imshow(imcomplement(img_sub_S1));
% % % %     F = img_sub_S1;
% % % %     
% % % %     level = graythresh(F);
% % % %     BW1 = im2bw(F, level);
% % % % %     figure, imshow(BW1);
% % % %         
% % % %     [fx, fy] = gradient(F);
% % % %     f = sqrt(fx.^2 + fy.^2);
% % % %     f = f / max(f(:));
% % % %     level = graythresh(f);
% % % %     BW = im2bw(f, 0.1); %0.08 for 212
% % % % %     figure, imshow(BW);
% % % %     f = double(BW) + double(BW1);
% % % %     f(find(f>1)) = 1;
% % % % %     figure, imshow(f);
% % % %     bw_f = im2bw(f, 0.5);
% % % % %     figure, imshow(bw_f);
% % % %     bw_f = imfill(bw_f, 8, 'holes');
% % % % %     figure, imshow(bw_f);
% % % %     img_bw_label = bwlabel(bw_f);
% % % %     stats = regionprops(bw_f, 'Area');
% % % %     areas = [stats.Area];
% % % %     idx_areas = find(areas > 500);
% % % %     img_bw = ismember(img_bw_label, idx_areas);
% % % % %     figure, imshow(img_bw);
% % % % %     figure, imshow(img_bw);
% % % %     imwrite(img_bw, ['./segmentation_res_S1/', 'CV_217_segmentation_S1_', sprintf('%05d', fr), '.bmp']);
% % % %     
% % % %     % detection of Slaver2 View
% % % %     img_ori_S2 = im2double(imread(['E:/FtpRoot/Dataset/CoreView_217/', 'CoreView_217_Slave2_Camera_', sprintf('%05d', fr), '.bmp']));
% % % %     img_bkd_S2 = im2double(imread(bkd_img_name_S2));
% % % %     img_sub_S2 = imsubtract(img_bkd_S2, img_ori_S2);
% % % %     [img_height, img_width] = size(img_ori_S2);
% % % % %     figure, imshow(imcomplement(img_sub_S2));
% % % %     F = img_sub_S2;
% % % %     
% % % %     level = graythresh(F);
% % % %     BW1 = im2bw(F, level);
% % % %     figure, imshow(BW1);
% % % %     close all; 
% % % %     [fx, fy] = gradient(F);
% % % %     f = sqrt(fx.^2 + fy.^2);
% % % %     f = f / max(f(:));
% % % %     level = graythresh(f);
% % % %     BW = im2bw(f, 0.1);
% % % %     figure, imshow(BW);
% % % %     f = double(BW) + double(BW1);
% % % %     f(find(f>1)) = 1;
% % % %     figure, imshow(f);
% % % %     bw_f = im2bw(f, 0.5);
% % % %     bw_f = imfill(bw_f, 8, 'holes');
% % % %     figure, imshow(bw_f);
% % % %     img_bw_label = bwlabel(bw_f);
% % % %     stats = regionprops(bw_f, 'Area');
% % % %     areas = [stats.Area];
% % % %     idx_areas = find(areas > 200);
% % % %     img_bw = ismember(img_bw_label, idx_areas);
% % % %     figure, imshow(img_bw);
% % % %     se = strel('rectangle', [1 1]);
% % % %     img_bw_2 = imdilate(img_bw, se);
% % % %     img_bw_2 = imfill(img_bw_2, 8, 'holes');
% % % %     figure, imshow(img_bw_2);
% % % %     imwrite(img_bw_2, ['./segmentation_res_S2/', 'CV_217_segmentation_S2_', sprintf('%05d', fr), '.bmp']);
% % % %     
% % % % %     hold on;
% % % % %     Detection(img_sub_M);
% % % % %     saveas(gcf, ['res_5/detection_res_', num2str(fr), '.jpg']);
% % % %     close all;
% % % %     toc;
% end


%--------------------read detection data--------------------%
% load meas_cv217_M_61-5060_DoH_step1
% load meas_S_CV217_325-1024;
% load meas_S_CV217_61-2060;
% load meas_cv217_midline_S1XS2_61-2060_Midline_step1;
% load meas_blobXmidline_cv217_S_325-865_Midline_step1
% load meas_cv213_midline_S1XS2_4500-6499_Midline_step1;
% % % % load meas_cv217_midline_S1XS2_2122-4121_Midline_step1

% %====================Tracking====================% %
%--------------------2d tracking in Master View (pre process)--------------------%
% Tracking_2D_Master();

%--------------------load 2d tracking results in Master View--------------------%
% load complete_trajs_CV217_325-865
% load manual_relinked_CV217_61-2060
% load manual_relinked_CV213_4500-6500
% % % % load manual_relinked_CV217_2122-4121

%--------------------data association Master X S1 X S2--------------------%
nfish = 10;
Tracking_Initialization();
for fr = bg_frame : delta_frame : ed_frame
    fr
    img_ori_M = im2double(imread([img_path, 'CoreView_217_Master_Camera_', sprintf('%05d', fr), '.bmp']));
    img_bkd_M = im2double(imread(bkd_img_name_M));
    img_sub_M = imsubtract(img_bkd_M, img_ori_M);
    img_ori_S1 = im2double(imread([img_path, 'CoreView_217_Slave1_Camera_', sprintf('%05d', fr), '.bmp']));
    img_bkd_S1 = im2double(imread(bkd_img_name_S1));
    img_sub_S1 = imsubtract(img_bkd_S1, img_ori_S1);
    img_ori_S2 = im2double(imread([img_path, 'CoreView_217_Slave2_Camera_', sprintf('%05d', fr), '.bmp']));
    img_bkd_S2 = im2double(imread(bkd_img_name_S2));
    img_sub_S2 = imsubtract(img_bkd_S2, img_ori_S2);
    
    Image_Binarization();
    
    State_Predict_LSTM();
    
%     Data_Association_with_Predict();

    Data_Association_with_Predict_Combine_2D();

%     Data_Association();
%     Data_Association_2();
%     Data_Association_3steps();
    tic;
end

% %====================SAVE results====================% %
save('raw_head_3d_trajs_cv217_2122-4121_3Views_with_Predict_0906.mat', 'trajs_3d');

% %====================postprocessing(relinking)====================% %
Traj_Postprocess()

% %====================plot 3d traj====================% %
Plot_Traj_3d();


