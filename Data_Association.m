function Data_Association()

global fr;
global meas;
global nseg;
global img_ori_S1;
global img_ori_M;
global img_ori_S2;
global F_matrix;
global Cam_Para;
global trajs_3d;
global trajs;
global thr_occ_cnt;
global thr_matching_dis_line_to_blob;
global thr_matching_dis_blob_to_blob;
global match_idx_s1;
global match_idx_s2;

dis_line_to_blob_m_s1 = Inf * ones(10, meas{fr}.view{2}.nblob);
dis_line_to_blob_m_s2 = Inf * ones(10, meas{fr}.view{3}.nblob);

% img_ori_M = im2double(imread(['E:/FtpRoot/Dataset/CoreView_217/', 'CoreView_217_Master_Camera_', sprintf('%05d', 325), '.bmp']));
% figure, imshow(img_ori_M);
% hold on;

% img_ori_S2 = im2double(imread(['E:/FtpRoot/Dataset/CoreView_217/', 'CoreView_217_Slave1_Camera_', sprintf('%05d', fr), '.bmp']));
% figure, imshow(img_ori_S2);
% hold on;

for obj_mi = 1 : 10 %length(trajs)
    if trajs{obj_mi}.ed_frame <= fr || trajs{obj_mi}.bg_frame > fr
        continue;
    end
    % % Master X Slave1
    points = trajs{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame + 1}.pt(:, 1 : 2)';
    points = flipud(points);
%     plot(points(1), points(2), 'r.');
    % calculate epipolar of midline 'obj_mi' of Master in Slave1
    epiLine_M_S1 = epipolarLine(F_matrix{1}.F, points);

%     epi_pts = lineToBorderPoints(epiLine_M_S1, size(img_ori_S2))';
%     line(epi_pts(:, [1,3])', epi_pts(:, [2,4])');
    
    % calculate sum of distance from the epipolar line in Slave1 to each
    % blob in Slave1
    for obj_s1i = 1 : meas{fr}.view{2}.nblob
        if meas{fr}.view{2}.obj{obj_s1i}.valid == 1
            points = meas{fr}.view{2}.obj{obj_s1i}.head_pt(:, 1 : 2)';
%             points = flipud(points);
%             plot(points(1), points(2), 'r.');
%             text(points(1), points(2), num2str(obj_s1i), 'Color', 'g', 'FontSize', 25);
            dis_line_to_blob_m_s1(obj_mi, obj_s1i) = 0;
            for epiline_i = 1 : size(epiLine_M_S1, 2)
                dis_line_to_blob_m_s1(obj_mi, obj_s1i) = dis_line_to_blob_m_s1(obj_mi, obj_s1i) + Dis_Line_to_Points(epiLine_M_S1(:, epiline_i), meas{fr}.view{2}.obj{obj_s1i}.head_pt);
%                 dis_line_to_blob_m_s1(obj_mi, obj_s1i) = dis_line_to_blob_m_s1(obj_mi, obj_s1i) + Dis_Line_to_Points(epiLine_M_S1(:, epiline_i), meas{fr}.view{2}.obj{obj_s1i}.blob_pts);
            end
        end
    end
    [min_val match_idx_s1(obj_mi)] = min(dis_line_to_blob_m_s1(obj_mi, :));
%     min_val
	if min_val > thr_matching_dis_line_to_blob
        match_idx_s1(obj_mi) = 0;
    end
    
    % % Master X Slave2
    points = trajs{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame + 1}.pt(:, 1 : 2)';
%     points = meas{fr}.view{1}.obj{obj_mi}.midline(:, 1 : 2)';
    points = flipud(points);
    % calculate epipolar of midline 'obj_mi' of Master in Slave1
    epiLine_M_S2 = epipolarLine(F_matrix{2}.F, points);
    
%     img_ori_S2 = im2double(imread(['E:/FtpRoot/Dataset/CoreView_217/', 'CoreView_217_Slave2_Camera_', sprintf('%05d', 325), '.bmp']));
%     epi_pts = lineToBorderPoints(epiLine_M_S2, size(img_ori_S2))';
% %     figure, imshow(img_ori_S2);
% %     hold on;
%     line(epi_pts(:, [1,3])', epi_pts(:, [2,4])');
    
    % calculate sum of distance from the epipolar line in Slave1 to each
    % blob in Slave1
    for obj_s2i = 1 : meas{fr}.view{3}.nblob
        if meas{fr}.view{3}.obj{obj_s2i}.valid == 1
            dis_line_to_blob_m_s2(obj_mi, obj_s2i) = 0;
            for epiline_i = 1 : size(epiLine_M_S2, 2)
                dis_line_to_blob_m_s2(obj_mi, obj_s2i) = dis_line_to_blob_m_s2(obj_mi, obj_s2i) + Dis_Line_to_Points(epiLine_M_S2(:, epiline_i), meas{fr}.view{3}.obj{obj_s2i}.head_pt(:, 1 : 2));
%                 dis_line_to_blob_m_s2(obj_mi, obj_s2i) = dis_line_to_blob_m_s2(obj_mi, obj_s2i) + Dis_Line_to_Points(epiLine_M_S2(:, epiline_i), meas{fr}.view{3}.obj{obj_s2i}.blob_pts(:, 1 : 2));
            end
        end
    end
    [min_val match_idx_s2(obj_mi)] = min(dis_line_to_blob_m_s2(obj_mi, :));
%     match_idx_s2(obj_mi)
%     min_val
    if min_val > thr_matching_dis_line_to_blob
        match_idx_s2(obj_mi) = 0;
    end
    
    % % DA discuss
    if match_idx_s1(obj_mi) == 0
        if match_idx_s2(obj_mi) == 0
            % if both S1 and S2 not matched, then lose this object
            match_success(obj_mi) = 0;
%             trajs_3d{obj_mi}.occ_cnt = trajs_3d{obj_mi}.occ_cnt + 1;
%             if trajs_3d{obj_mi}.occ_cnt >= 3
%                 trajs_3d{obj_mi}.inactive = 1;
%             end
        else
%             % if S2 matched but S1 not, then if occ_cnt < thr, match
%             % success, otherwise fail
%             if trajs_3d{obj_mi}.occ_cnt >= 3
%                 match_success(obj_mi) = 0;
%                 trajs_3d{obj_mi}.inactive = 1;
%             else
%                 trajs_3d{obj_mi}.occ_cnt = 0;
%                 trajs_3d{obj_mi}.occ_cnt = trajs_3d{obj_mi}.occ_cnt + 1;
                match_success(obj_mi) = 1;
%             end
        end
    else
        if match_idx_s2(obj_mi) == 0
            % if S1 matched but S2 not, then if occ_cnt < thr, match
            % success, otherwise fail
%             if trajs_3d{obj_mi}.occ_cnt >= 3
                match_success(obj_mi) = 1;
%                 trajs_3d{obj_mi}.inactive = 1;
%             else
%                 trajs_3d{obj_mi}.occ_cnt = trajs_3d{obj_mi}.occ_cnt + 1;
%                 match_success(obj_mi) = 1;
%             end
        else
            % if both S1 and S2 matched, then judge S1 X S2
            points = meas{fr}.view{2}.obj{match_idx_s1(obj_mi)}.head_pt(:, 1 : 2)';
%             points = flipud(points);
            epiLine_S1_S2 = epipolarLine(F_matrix{3}.F, points); 
%             points = meas{fr}.view{3}.obj{match_idx_s2(obj_mi)}.head_pt(:, 1 : 2)';
%             plot(points(1), points(2), 'r.');
%             text(points(1), points(2), num2str(match_idx_s2(obj_mi)), 'Color', 'g', 'FontSize', 25);
%             epi_pts = lineToBorderPoints(epiLine_S1_S2, size(img_ori_S2))';
%             line(epi_pts(:, [1,3])', epi_pts(:, [2,4])');
    
            dis_line_to_blob_s1_s2 = 0;
            for epiline_i = 1 : size(epiLine_S1_S2, 2)
                dis_line_to_blob_s1_s2 = dis_line_to_blob_s1_s2 + Dis_Line_to_Points(epiLine_S1_S2(:, epiline_i), meas{fr}.view{3}.obj{match_idx_s2(obj_mi)}.head_pt(:, 1 : 2));
            end
%             dis_line_to_blob_s1_s2
            if dis_line_to_blob_s1_s2 < thr_matching_dis_blob_to_blob
                match_success(obj_mi) = 1;
%                 trajs_3d{obj_mi}.occ_cnt = 0;
            else
                match_success(obj_mi) = 0;
                match_idx_s1(obj_mi) = 0;
                match_idx_s2(obj_mi) = 0;
                trajs_3d{obj_mi}.inactive = 1;
            end
        end
    end
    
    % Reconstruction
    if match_success(obj_mi) == 1
%         if mod(fr, 2) == 0
        if match_idx_s1(obj_mi) ~= 0
%             if match_idx_s2(obj_mi) ~= 0
                trajs_3d{obj_mi}.traj{fr - trajs_3d{obj_mi}.bg_frame + 1}.view_flag = 1;
                [XL, XR] = stereo_triangulation(flipud(trajs{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame + 1}.pt(1, 1 : 2)'), meas{fr}.view{2}.obj{match_idx_s1(obj_mi)}.head_pt(1, 1 : 2)', F_matrix{1}.om, F_matrix{1}.T', Cam_Para{1}.fc, Cam_Para{1}.cc, Cam_Para{1}.kc, Cam_Para{1}.alpha_c, Cam_Para{2}.fc, Cam_Para{2}.cc, Cam_Para{2}.kc, Cam_Para{2}.alpha_c);
%                 XR2 = Translate_to_Right_View(XL, F_matrix{1}.om, F_matrix{1}.T);
%                 Xp = Reproject_to_2D(XR2, Cam_Para{2}.kc, Cam_Para{2}.fc, Cam_Para{2}.cc, Cam_Para{2}.alpha_c);
%                 plot(Xp(1, :), Xp(2, :), 'r.');
%                 plot(trajs{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame + 1}.pt(1, 2), trajs{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame + 1}.pt(1, 1), 'g.');
%                 plot(meas{fr}.view{2}.obj{match_idx_s1(obj_mi)}.head_pt(1, 1), meas{fr}.view{2}.obj{match_idx_s1(obj_mi)}.head_pt(1, 2), 'y.');
%                 text(Xp(1, :), Xp(2, :), num2str(match_idx_s1(obj_mi)), 'Color', 'b', 'FontSize', 25);
%                 XRR = P * XL;
%                 img_r = imread('Slave1_150713_1.bmp');
%                 figure, imshow(img_r);
%                 hold on;
%                 plot(XRR(1)/XRR(3), XRR(2)/XRR(3), 'r.');
%             else
%                 [XL, XR] = stereo_triangulation(trajs{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame + 1}.pt(1, 1 : 2)', meas{fr}.view{2}.obj{match_idx_s1(obj_mi)}.head_pt(1, 1 : 2)', F_matrix{1}.om, F_matrix{1}.T', Cam_Para{1}.fc, Cam_Para{1}.cc, Cam_Para{1}.kc, Cam_Para{1}.alpha_c, Cam_Para{2}.fc, Cam_Para{2}.cc, Cam_Para{2}.kc, Cam_Para{2}.alpha_c);
%             end
        else
            if match_idx_s2(obj_mi) ~= 0
                trajs_3d{obj_mi}.traj{fr - trajs_3d{obj_mi}.bg_frame + 1}.view_flag = 2;
                [XL, XR] = stereo_triangulation(flipud(trajs{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame + 1}.pt(1, 1 : 2)'), meas{fr}.view{3}.obj{match_idx_s2(obj_mi)}.head_pt(1, 1 : 2)', F_matrix{2}.om, F_matrix{2}.T', Cam_Para{1}.fc, Cam_Para{1}.cc, Cam_Para{1}.kc, Cam_Para{1}.alpha_c, Cam_Para{3}.fc, Cam_Para{3}.cc, Cam_Para{3}.kc, Cam_Para{3}.alpha_c);
            else
                XL = zeros(3, 1);
                XR = zeros(3, 1);
            end
        end
        trajs_3d{obj_mi}.traj{fr - trajs_3d{obj_mi}.bg_frame + 1}.head_pt = XL;
    else
        trajs_3d{obj_mi}.traj{fr - trajs_3d{obj_mi}.bg_frame + 1}.head_pt = zeros(3, 1);
    end
    
end

end