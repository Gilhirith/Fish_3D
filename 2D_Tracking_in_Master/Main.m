close all;
clear all;
clc;


% for i = 1 : 2000
%     img_ori_M = imread(['D:/20160617/11_Stone/CoreView_338_Flare_4M180_NCL_(2)_', sprintf('%05d', i), '.bmp']);
%     imwrite(img_ori_M, ['D:/20160617/11_Stone_jpg/CoreView_338_Flare_4M180_NCL_', sprintf('%05d', i), '.jpg'] , 'jpg', 'quality',90)
% end


global bg_frame;
global ed_frame;
global delta_frame;
global meas;
global trajs;
global search_radius;
global cnn;
global img1;

bg_frame = 2122;
ed_frame = 4121;
delta_frame = 1;
search_radius = 50;

% load CNN_res_fish27_balanced_meanbkd_11992_batch2_itr400_to3;
% load('weight_image_CoreView54.mat', 'img1');
% load('trajs_fish27_CoreView340_1-599_step2_final.mat');

% addpath(genpath('D:/Uriel/Fish_CNN/rasmusbergpalm-DeepLearnToolbox-9faf641/'));
% load('trajectories_275_idTracker_nogaps.mat');
% 
% nn = zeros(10, 1);
% idx = 2 : 1 : 2000;
% for i = 1 : 10
%     for j = 1 : 1 : 2000
%         if isnan(trajectories(j, i, 1))
%             nn(i) = nn(i) + 1;
%         end
%     end
% end
 
% % load meas
% % load('meas_CoreView54_1-500_step1_nolimit.mat');
% load('meas_CoreView241_222-521_step1_nolimit.mat');
% meas1 = meas;
% load('meas_CoreView241_522-1221_step1_nolimit.mat');
% meas2 = meas;
% load('meas_CoreView241_1222-1905_step1_nolimit.mat');
% meas3 = meas;
% load('meas_cv275_2400-2512.mat');
% load ('meas_cv217_M_61-1060_DoH_step1.mat');
% load('../meas_cv217_M_61-5060_DoH_step1.mat');
% % % % % % % % load('../meas_cv340_DoH_M_1-559_step1.mat');
% 
% for i = 973 : 973
%     img_prefix = 'G:/Zebrafish_seg_tracking/275/CoreView_275_Master_Camera_00973.bmp';
%     img = imread(img_prefix);
%     figure, imshow(img);
%     hold on;
%     for j = 1 : length(meas{i}.obj)
%         plot(meas{i}.obj{j}.midline(:, 2), meas{i}.obj{j}.midline(:, 1), 'r.', 'LineWidth', 2);
%     end
% end
% 
% tic;

% meas1 = meas;
% load('meas_CoreView241_2222-2721_step1_nolimit.mat');
% for i = 222 : 2221
%     meas{i} = meas1{i};
% end
% for i = 522 : 1221
%     meas{i} = meas2{i};
% end
% for i = 1222 : 1899
%     meas{i} = meas3{i};
% end
% tic;
% cnt = 0;
% for i = 1901 : 2200
%     img = im2double(imread(['../Fish_2D_CNN/CoreView_10/CoreView_10_Master_Camera_', sprintf('%04d', i), '.bmp']));
%     figure, imshow(img);
%     hold on;
%     for j = 1 : length(meas{i}.pts)
%         plot(meas{i}.pts(j, 2), meas{i}.pts(j, 1), 'b.');
%     end
%     saveas(gcf, ['res_CoreView10_1-300/dec_', sprintf('%04d', i), '.jpg']);
%     close all;
% %     cnt = cnt + length(meas{i}.pts);
% end
% cnt


% load ('../meas_cv217_M_61-5060_Midline_step1.mat');
% meas1 = meas;
% clear meas;
% 
% for i = 2122 : 4121
%     meas{i}.view{1} = meas1{i};
% end
% 
% save('../meas_cv217_M_2122-4121_Midline_step1_view1.mat', 'meas', '-v7.3');

load('../meas_cv217_M_2122-4121_DoH_step1.mat');

tracking();

% load('../meas_cv340_DoH_M_1-2000_Midline_step1.mat');


% tracking_CNN();
% meas{646}.obj{1} = meas{645}.obj{1};
% meas{802}.obj{1} = meas{803}.obj{1};
% meas{836}.obj{2} = meas{835}.obj{2};
% rev_list = [543, 8; 569, 7; 804, 1; 830, 2; 831, 2; 832, 2; 833, 2; 834, 2; 835, 2; 836, 2; 837, 2];
% for i = 1 : size(rev_list, 1)
%     tpt = meas{rev_list(i, 1)}.obj{rev_list(i, 2)}.head_pt; 
%     meas{rev_list(i, 1)}.obj{rev_list(i, 2)}.head_pt = meas{rev_list(i, 1)}.obj{rev_list(i, 2)}.tail_pt;
%     meas{rev_list(i, 1)}.obj{rev_list(i, 2)}.tail_pt = tpt;
% end
% img_prefix = 'G:/Zebrafish_seg_tracking/275/CoreView_275_Master_Camera_';
% img_original = im2double(imread([img_prefix, sprintf('%05d', 831), '.bmp']));
% figure, imshow(img_original);
% hold on;
% for i = 1 : 10
%     plot(meas{831}.obj{i}.head_pt(1, 2),meas{831}.obj{i}.head_pt(1, 1), 'r.');
% end
% tracking_midline();
save('raw_trajs_CV217_2122-4121_radius50.mat', 'trajs');

tic;
% relinking();
% load('raw_trajs_1-2000_150909.mat', 'trajs');
% plot_traj();
% 
% save('raw_trajs_CV241_222-521_150909.mat', 'trajs');

% load('meas_CoreView241_222-721_step1_nolimit.mat');

% res = 0;
% for i = 1 : 78
%     if trajs{i}.ed_frame == -1
%         trajs{i}.ed_frame = 501;
%     end
%     len = trajs{i}.ed_frame - trajs{i}.bg_frame;
%     if len >= 4
%         res = res + 1;
%     end
% end
% 
% res
% 
% cnt = 0;
% cnt1 = 0;
% cnt2 = 0;
% cnt3 = 0;
% 
% for j = 1 : length(trajs)
%     if trajs{j}.ed_frame == -1
%         trajs{j}.ed_frame = ed_frame + 1;
%     end
%     len = (trajs{j}.ed_frame - trajs{j}.bg_frame) / delta_frame;
%     if len >= 400
%         cnt1 = cnt1 + 1;
%     end
%     if len <= 100
%         cnt3 = cnt3 + 1;
%     end
%     if len < 400 && len > 100
%         
%         cnt2 = cnt2 + 1;
%     end
% %     if (trajs{j}.ed_frame - trajs{j}.bg_frame) / delta_frame > 0.8 * (ed_frame - bg_frame + 1)
% %         
% %     end
% end
% 
% cnt1
% cnt2
% cnt3