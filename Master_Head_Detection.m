function points = Master_Head_Detection()
    
    global img_height;
    global img_width;
    global bkd_img_name;
    global sample_ht;
    global sample_wd;
    global trained_cnn_mat;
    global res;
    global nfish;
    global trajs;
    global meas;
    global search_radius;
    global img_ori_M;
    global img_bkd_M;
    global img_sub_M;
    global fr;
    global img_adj;
    
    sample_ht = 48;
    sample_wd = 48;
    res = 0;
    search_radius = 80;
    
    img_bw = im2bw(img_sub_M, 0.2); %0.25 0.47
%     figure, imshow(img_bw);
%     img_bw = im2bw(img_sub_M, 0.1); %0.25
%     figure, imshow(img_bw);
    img_bw_label = bwlabel(img_bw);
    stats = regionprops(img_bw, 'Area');
    areas = [stats.Area];
    idx_areas = find(areas > 200);
    img_bw = ismember(img_bw_label, idx_areas);
    img_bw = imfill(img_bw, 'holes');
    se = strel('disk',1);
    img_bw = imclose(img_bw, se);
    img_bw_label = bwlabel(img_bw);
%     figure, imshow(img_bw);
%     hold on;
% %     figure, imshow(img_sub_M);
% %     hold on;
    boundary = bwboundaries(img_bw);
    points = DoH(img_sub_M, img_bw, img_bw_label, boundary);
    plot(points(:, 2), points(:, 1), 'r.');
%     res
%     save('meas_CoreView278_2001-4000_step1_nolimit.mat', 'meas');
%     save('raw_trajs_CNN_res_fish26_balanced_2101-2400_level6_5_5_4_6_12_12_to3.mat', 'trajs');
end