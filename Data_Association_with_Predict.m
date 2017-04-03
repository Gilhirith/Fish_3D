function Data_Association_with_Predict()

global fr;
global meas;
global nseg;
global nfish;
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
global thr_vel_2d;
global match_idx_s1;
global match_idx_s2;
global delta_frame;
global img_bw_M;
global img_bw_S1;
global img_bw_S2;
global motion_predict;
global bg_frame;

% %----------------------Initialization----------------------% %
dis_line_to_blob_m_s1 = Inf * ones(10, meas{fr}.view{2}.nblob);
dis_line_to_blob_m_s2 = Inf * ones(10, meas{fr}.view{3}.nblob);

matching_flag_slave1 = zeros(meas{fr}.view{2}.nblob, 1);
matching_flag_slave2 = zeros(meas{fr}.view{3}.nblob, 1);

match_success = zeros(1, nfish);

pre_3d = -1 * ones(3, nfish);
pre_3d_fr = zeros(nfish, 1);
% %----------------------Pre-Step: 3D state predict----------------------% %
if fr > bg_frame
    for i = 1 : length(trajs_3d)
        trajs_3d{i}.traj{fr - trajs_3d{i}.bg_frame + 1}.vel = trajs_3d{i}.traj{fr - trajs_3d{i}.bg_frame}.vel + motion_predict(i, :)';
        trajs_3d{i}.traj{fr - trajs_3d{i}.bg_frame + 1}.head_pt = zeros(3, 1);%trajs_3d{i}.traj{fr - trajs_3d{i}.bg_frame}.head_pt + trajs_3d{i}.traj{fr - bg_frame}.vel + motion_predict(i, :)';
    end
end
        
% img_ori_M = im2double(imread(['E:/FtpRoot/Dataset/CoreView_217/', 'CoreView_217_Master_Camera_', sprintf('%05d', 325), '.bmp']));
% figure, imshow(img_ori_M);
% hold on;

% %----------------------STEP 1: Master X Slave1 X Slave2----------------------% %
for obj_mi = 1 : nfish %length(trajs)
    if trajs{obj_mi}.ed_frame <= fr || trajs{obj_mi}.bg_frame > fr
        continue;
    end
    
    if trajs{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame + 1}.pt(1, 1) == 0
        continue;
    end
    
    % % 2D coordinates in Master View
    trajs_3d{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame + 1}.view{1}.head_pt_2d = trajs{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame + 1}.pt(1, 1 : 2)';
    
    % % Master X Slave1
    points = flipud(trajs{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame + 1}.pt(:, 1 : 2)');
%     plot(points(1), points(2), 'r.');

    % % calculate epipolar of midline 'obj_mi' of Master in Slave1
    epiLine_M_S1 = epipolarLine(F_matrix{1}.F, points);
    
    % % draw epipolar line in Slave1
%     epi_pts = lineToBorderPoints(epiLine_M_S1, size(img_ori_S2))';
%     line(epi_pts(:, [1,3])', epi_pts(:, [2,4])');
    
    % % sum of distance from the epipolar line in Slave1 to each blob in Slave1
    for obj_s1i = 1 : meas{fr}.view{2}.nblob
        if meas{fr}.view{2}.obj{obj_s1i}.valid == 1
            points = meas{fr}.view{2}.obj{obj_s1i}.head_pt(:, 1 : 2)';
%             if pre_pt{1}.pre_fr > 0
%                 delta_dis_slave_2d = norm(pre_pt{1}.pt - points);
%                 if delta_dis_slave_2d > thr_vel_2d% * (fr - pre_pt{1}.pre_fr)
%                     dis_line_to_blob_m_s1(obj_mi, obj_s1i) = Inf;
%                     continue;
%                 end
%             end
            if fr - trajs{obj_mi}.bg_frame - delta_frame + 1 > 0
                if trajs_3d{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame - delta_frame + 1}.view{2}.head_pt_2d(1) ~= -1
                    delta_dis_slave_2d = sqrt(sum((points - trajs_3d{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame - delta_frame + 1}.view{2}.head_pt_2d).^2));
                    if delta_dis_slave_2d > thr_vel_2d
                        dis_line_to_blob_m_s1(obj_mi, obj_s1i) = Inf;
                        continue;
                    end
                end
            end
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
	if min_val > thr_matching_dis_line_to_blob
        match_idx_s1(obj_mi) = 0;
    end
    
    % % Master X Slave2
    points = flipud(trajs{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame + 1}.pt(:, 1 : 2)');
%     points = meas{fr}.view{1}.obj{obj_mi}.midline(:, 1 : 2)';

    % % calculate epipolar of midline 'obj_mi' of Master in Slave2
    epiLine_M_S2 = epipolarLine(F_matrix{2}.F, points);
    
    % % sum of distance from the epipolar line in Slave1 to each blob in Slave2
    for obj_s2i = 1 : meas{fr}.view{3}.nblob
        if meas{fr}.view{3}.obj{obj_s2i}.valid == 1
            points = meas{fr}.view{3}.obj{obj_s2i}.head_pt(:, 1 : 2)';
%             if pre_pt{2}.pre_fr > 0
%                 delta_dis_slave_2d = norm(pre_pt{2}.pt - points);
%                 if delta_dis_slave_2d > thr_vel_2d% * (fr - pre_pt{2}.pre_fr)
%                     dis_line_to_blob_m_s2(obj_mi, obj_s2i) = Inf;
%                     continue;
%                 end
%             end
            if fr - trajs{obj_mi}.bg_frame - delta_frame + 1 > 0
                if trajs_3d{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame - delta_frame + 1}.view{3}.head_pt_2d(1) ~= -1
                    delta_dis_slave_2d = norm(points - trajs_3d{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame - delta_frame + 1}.view{3}.head_pt_2d);
                    if delta_dis_slave_2d > thr_vel_2d
                        dis_line_to_blob_m_s2(obj_mi, obj_s2i) = Inf;
                        continue;
                    end
                end
            end
            dis_line_to_blob_m_s2(obj_mi, obj_s2i) = 0;
            for epiline_i = 1 : size(epiLine_M_S2, 2)
                dis_line_to_blob_m_s2(obj_mi, obj_s2i) = dis_line_to_blob_m_s2(obj_mi, obj_s2i) + Dis_Line_to_Points(epiLine_M_S2(:, epiline_i), meas{fr}.view{3}.obj{obj_s2i}.head_pt(:, 1 : 2));
            end
        end
    end
    [min_val match_idx_s2(obj_mi)] = min(dis_line_to_blob_m_s2(obj_mi, :));
    if min_val > thr_matching_dis_line_to_blob
        match_idx_s2(obj_mi) = 0;
    end
    
    % % DA across 3 views
    if match_idx_s1(obj_mi) == 0
        if match_idx_s2(obj_mi) == 0
            % if both S1 and S2 not matched, then lose this object
            match_success(obj_mi) = 0;
            trajs_3d{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame + 1}.view{2}.head_pt_2d = -1 * ones(2, 1);
            trajs_3d{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame + 1}.view{3}.head_pt_2d = -1 * ones(2, 1);
            trajs_3d{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame + 1}.match_idx_s1 = 0;
            trajs_3d{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame + 1}.match_idx_s2 = 0;
        else

            match_success(obj_mi) = 0;
            trajs_3d{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame + 1}.view{2}.head_pt_2d = -1 * ones(2, 1);
            trajs_3d{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame + 1}.view{3}.head_pt_2d = meas{fr}.view{3}.obj{match_idx_s2(obj_mi)}.head_pt';
            trajs_3d{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame + 1}.match_idx_s1 = 0;
            trajs_3d{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame + 1}.match_idx_s2 = match_idx_s2(obj_mi);
        end
    else
        if match_idx_s2(obj_mi) == 0
            match_success(obj_mi) = 0;
            trajs_3d{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame + 1}.view{2}.head_pt_2d = meas{fr}.view{2}.obj{match_idx_s1(obj_mi)}.head_pt';
            trajs_3d{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame + 1}.view{3}.head_pt_2d = -1 * ones(2, 1);
            trajs_3d{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame + 1}.match_idx_s1 = match_idx_s1(obj_mi);
            trajs_3d{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame + 1}.match_idx_s2 = 0;
        else
            % % if both S1 and S2 matched, then judge S1 X S2
            points = meas{fr}.view{2}.obj{match_idx_s1(obj_mi)}.head_pt(:, 1 : 2)';
            epiLine_S1_S2 = epipolarLine(F_matrix{3}.F, points);
    
            dis_line_to_blob_s1_s2 = 0;
            for epiline_i = 1 : size(epiLine_S1_S2, 2)
                dis_line_to_blob_s1_s2 = dis_line_to_blob_s1_s2 + Dis_Line_to_Points(epiLine_S1_S2(:, epiline_i), meas{fr}.view{3}.obj{match_idx_s2(obj_mi)}.head_pt(:, 1 : 2));
            end
            if dis_line_to_blob_s1_s2 < thr_matching_dis_blob_to_blob
                match_success(obj_mi) = 1;
                trajs_3d{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame + 1}.match_idx_s1 = match_idx_s1(obj_mi);
                trajs_3d{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame + 1}.match_idx_s2 = match_idx_s2(obj_mi);
                trajs_3d{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame + 1}.view{2}.head_pt_2d = meas{fr}.view{2}.obj{match_idx_s1(obj_mi)}.head_pt';
                trajs_3d{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame + 1}.view{3}.head_pt_2d = meas{fr}.view{3}.obj{match_idx_s2(obj_mi)}.head_pt';
                matching_flag_slave1(match_idx_s1(obj_mi)) = 1;
                matching_flag_slave2(match_idx_s2(obj_mi)) = 1;
            else
                match_success(obj_mi) = 0;
                match_idx_s1(obj_mi) = 0;
                match_idx_s2(obj_mi) = 0;
                trajs_3d{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame + 1}.match_idx_s1 = 0;
                trajs_3d{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame + 1}.match_idx_s2 = 0;
                trajs_3d{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame + 1}.view{2}.head_pt_2d = -1 * ones(2, 1);
                trajs_3d{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame + 1}.view{3}.head_pt_2d = -1 * ones(2, 1);
                trajs_3d{obj_mi}.inactive = 1;
            end
        end
    end
end

% % % % %----------------------STEP 2: Master X Slave1(unmatched)----------------------% %
% % % disp('step2\n');
% % % unmatched_idx_s1 = find(matching_flag_slave1 == 0);
% % % unmatched_idx_m = find(match_success == 0);
% % % dis_line_to_blob_m_s1 = Inf * ones(length(unmatched_idx_m), length(unmatched_idx_s1));
% % % 
% % % for obj_mi = 1 : length(unmatched_idx_m)
% % % 
% % %     if trajs{unmatched_idx_m(obj_mi)}.ed_frame <= fr || trajs{unmatched_idx_m(obj_mi)}.bg_frame > fr
% % %         continue;
% % %     end
% % %     
% % %     if trajs{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame + 1}.pt(1, 1) == 0
% % %         continue;
% % %     end
% % %     
% % %     % % Master X Slave1
% % %     points = flipud(trajs{unmatched_idx_m(obj_mi)}.traj{fr - trajs{unmatched_idx_m(obj_mi)}.bg_frame + 1}.pt(:, 1 : 2)');
% % % 
% % %     % % calculate epipolar of midline 'obj_mi' of Master in Slave1
% % %     epiLine_M_S1 = epipolarLine(F_matrix{1}.F, points);
% % %     
% % %     % % sum of distance from the epipolar line in Slave1 to each blob in Slave1
% % %     for obj_s1i = 1 : length(unmatched_idx_s1)
% % %         if meas{fr}.view{2}.obj{unmatched_idx_s1(obj_s1i)}.valid == 1
% % %             points = meas{fr}.view{2}.obj{unmatched_idx_s1(obj_s1i)}.head_pt(:, 1 : 2)';
% % %             if fr - trajs{unmatched_idx_m(obj_mi)}.bg_frame - delta_frame + 1 > 0
% % %                 if trajs_3d{unmatched_idx_m(obj_mi)}.traj{fr - trajs{unmatched_idx_m(obj_mi)}.bg_frame - delta_frame + 1}.view{2}.head_pt_2d(1) ~= -1
% % %                     delta_dis_slave_2d = sqrt(sum((points - trajs_3d{unmatched_idx_m(obj_mi)}.traj{fr - trajs{unmatched_idx_m(obj_mi)}.bg_frame - delta_frame + 1}.view{2}.head_pt_2d).^2));
% % %                     if delta_dis_slave_2d > thr_vel_2d
% % %                         dis_line_to_blob_m_s1(obj_mi, obj_s1i) = Inf;
% % %                         continue;
% % %                     end
% % %                 end
% % %             end
% % %             dis_line_to_blob_m_s1(obj_mi, obj_s1i) = 0;
% % %             for epiline_i = 1 : size(epiLine_M_S1, 2)
% % %                 dis_line_to_blob_m_s1(obj_mi, obj_s1i) = dis_line_to_blob_m_s1(obj_mi, obj_s1i) + Dis_Line_to_Points(epiLine_M_S1(:, epiline_i), meas{fr}.view{2}.obj{unmatched_idx_s1(obj_s1i)}.head_pt);
% % %             end
% % %         end
% % %     end
% % %     if length(unmatched_idx_s1) > 0
% % %         [min_val match_idx_s1(unmatched_idx_m(obj_mi))] = min(dis_line_to_blob_m_s1(obj_mi, :));
% % %         [XL, XR] = stereo_triangulation(flipud(trajs{unmatched_idx_m(obj_mi)}.traj{fr - trajs{unmatched_idx_m(obj_mi)}.bg_frame + 1}.pt(1, 1 : 2)'), meas{fr}.view{2}.obj{unmatched_idx_s1(obj_s1i)}.head_pt(1, 1 : 2)', F_matrix{1}.om, F_matrix{1}.T', Cam_Para{1}.fc, Cam_Para{1}.cc, Cam_Para{1}.kc, Cam_Para{1}.alpha_c, Cam_Para{2}.fc, Cam_Para{2}.cc, Cam_Para{2}.kc, Cam_Para{2}.alpha_c);
% % %         XR = Translate_to_Right_View(XL, F_matrix{2}.om, F_matrix{2}.T);
% % %         Xp = Reproject_to_2D(XR, Cam_Para{3}.kc, Cam_Para{3}.fc, Cam_Para{3}.cc, Cam_Para{3}.alpha_c);
% % %         if min_val > thr_matching_dis_line_to_blob || Check_Epipolar_Constraint(Xp, img_bw_S2) == 0
% % %             match_idx_s1(unmatched_idx_m(obj_mi)) = 0;
% % %         else
% % %             disp('here 1\n');
% % %             match_success(unmatched_idx_m(obj_mi)) = 1;
% % %             matching_flag_slave1(unmatched_idx_s1(obj_s1i)) = 1;
% % %         end
% % %     end
% % % end
% % % 
% % % % %----------------------STEP 3: Master X Slave2(unmatched)----------------------% %
% % % disp('step3\n');
% % % unmatched_idx_s2 = find(matching_flag_slave2 == 0);
% % % unmatched_idx_m = find(match_success == 0);
% % % dis_line_to_blob_m_s2 = Inf * ones(length(unmatched_idx_m), length(unmatched_idx_s2));
% % % 
% % % for obj_mi = 1 : length(unmatched_idx_m)
% % %     if trajs{unmatched_idx_m(obj_mi)}.ed_frame <= fr || trajs{unmatched_idx_m(obj_mi)}.bg_frame > fr
% % %         continue;
% % %     end
% % %     
% % %     if trajs{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame + 1}.pt(1, 1) == 0
% % %         continue;
% % %     end
% % %     
% % %     % % Master X Slave1
% % %     points = flipud(trajs{unmatched_idx_m(obj_mi)}.traj{fr - trajs{unmatched_idx_m(obj_mi)}.bg_frame + 1}.pt(:, 1 : 2)');
% % % 
% % %     % % calculate epipolar of midline 'obj_mi' of Master in Slave1
% % %     epiLine_M_S2 = epipolarLine(F_matrix{2}.F, points);
% % %     
% % %     % % sum of distance from the epipolar line in Slave1 to each blob in Slave1
% % %     for obj_s2i = 1 : length(unmatched_idx_s2)
% % %         if meas{fr}.view{3}.obj{unmatched_idx_s2(obj_s2i)}.valid == 1
% % %             points = meas{fr}.view{3}.obj{unmatched_idx_s2(obj_s2i)}.head_pt(:, 1 : 2)';
% % %             if fr - trajs{unmatched_idx_m(obj_mi)}.bg_frame - delta_frame + 1 > 0
% % %                 if trajs_3d{unmatched_idx_m(obj_mi)}.traj{fr - trajs{unmatched_idx_m(obj_mi)}.bg_frame - delta_frame + 1}.view{3}.head_pt_2d(1) ~= -1
% % %                     delta_dis_slave_2d = sqrt(sum((points - trajs_3d{unmatched_idx_m(obj_mi)}.traj{fr - trajs{unmatched_idx_m(obj_mi)}.bg_frame - delta_frame + 1}.view{3}.head_pt_2d).^2));
% % %                     if delta_dis_slave_2d > thr_vel_2d
% % %                         dis_line_to_blob_m_s2(obj_mi, obj_s2i) = Inf;
% % %                         continue;
% % %                     end
% % %                 end
% % %             end
% % %             dis_line_to_blob_m_s2(obj_mi, obj_s2i) = 0;
% % %             for epiline_i = 1 : size(epiLine_M_S2, 2)
% % %                 dis_line_to_blob_m_s2(obj_mi, obj_s2i) = dis_line_to_blob_m_s2(obj_mi, obj_s2i) + Dis_Line_to_Points(epiLine_M_S2(:, epiline_i), meas{fr}.view{3}.obj{unmatched_idx_s2(obj_s2i)}.head_pt);
% % %             end
% % %         end
% % %     end
% % %     if length(unmatched_idx_s2) > 0
% % %         [min_val match_idx_s2(unmatched_idx_m(obj_mi))] = min(dis_line_to_blob_m_s2(obj_mi, :));
% % %         [XL, XR] = stereo_triangulation(flipud(trajs{unmatched_idx_m(obj_mi)}.traj{fr - trajs{unmatched_idx_m(obj_mi)}.bg_frame + 1}.pt(1, 1 : 2)'), meas{fr}.view{3}.obj{unmatched_idx_s2(obj_s2i)}.head_pt(1, 1 : 2)', F_matrix{2}.om, F_matrix{2}.T', Cam_Para{1}.fc, Cam_Para{1}.cc, Cam_Para{1}.kc, Cam_Para{1}.alpha_c, Cam_Para{3}.fc, Cam_Para{3}.cc, Cam_Para{3}.kc, Cam_Para{3}.alpha_c);
% % %         XR = Translate_to_Right_View(XL, F_matrix{1}.om, F_matrix{1}.T);
% % %         Xp = Reproject_to_2D(XR, Cam_Para{2}.kc, Cam_Para{2}.fc, Cam_Para{2}.cc, Cam_Para{2}.alpha_c);
% % %         if min_val > thr_matching_dis_line_to_blob || Check_Epipolar_Constraint(Xp, img_bw_S1) == 0
% % %             match_idx_s2(unmatched_idx_m(obj_mi)) = 0;
% % %         else
% % %             disp('here 2\n');
% % %             match_success(unmatched_idx_m(obj_mi)) = 1;
% % %             matching_flag_slave2(unmatched_idx_s2(obj_s2i)) = 1;
% % %         end
% % %     end
% % % end


% %----------------------STEP 4: Reconstruction----------------------% %
for obj_mi = 1 : nfish
    if match_success(obj_mi) == 1
%         if mod(fr, 2) == 0
        if match_idx_s1(obj_mi) ~= 0 && match_idx_s2(obj_mi) ~= 0
%             if match_idx_s2(obj_mi) ~= 0
            trajs_3d{obj_mi}.traj{fr - trajs_3d{obj_mi}.bg_frame + 1}.view_flag = 1;
            [XL, XR] = stereo_triangulation(flipud(trajs{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame + 1}.pt(1, 1 : 2)'), meas{fr}.view{2}.obj{match_idx_s1(obj_mi)}.head_pt(1, 1 : 2)', F_matrix{1}.om, F_matrix{1}.T', Cam_Para{1}.fc, Cam_Para{1}.cc, Cam_Para{1}.kc, Cam_Para{1}.alpha_c, Cam_Para{2}.fc, Cam_Para{2}.cc, Cam_Para{2}.kc, Cam_Para{2}.alpha_c);
            if pre_3d(1, obj_mi) == -1
                pre_3d(:, obj_mi) = XL;
                pre_3d_fr(obj_mi) = fr;
            end
            dis = norm(pre_3d(:, obj_mi) - XL);
%             if dis < 300 * (fr - pre_3d_fr(obj_mi))
                trajs_3d{obj_mi}.traj{fr - trajs_3d{obj_mi}.bg_frame + 1}.head_pt = XL;
%                 pre_pt{1}.pt = meas{fr}.view{2}.obj{match_idx_s1(obj_mi)}.head_pt(1, 1 : 2)';
%                 pre_pt{1}.pre_fr = fr;
                pre_3d(:, obj_mi) = XL;
                pre_3d_fr(obj_mi) = fr;
%                 pre_pt{2}.pt = meas{fr}.view{3}.obj{match_idx_s2(obj_mi)}.head_pt(1, 1 : 2)';
%                 pre_pt{2}.pre_fr = fr;
%             end
            
%             end
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
%             trajs_3d{obj_mi}.traj{fr - trajs_3d{obj_mi}.bg_frame + 1}.head_pt = zeros(3, 1);
            
%             if match_idx_s2(obj_mi) ~= 0
                trajs_3d{obj_mi}.traj{fr - trajs_3d{obj_mi}.bg_frame + 1}.view_flag = 2;
                [XL, XR] = stereo_triangulation(flipud(trajs{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame + 1}.pt(1, 1 : 2)'), meas{fr}.view{3}.obj{match_idx_s2(obj_mi)}.head_pt(1, 1 : 2)', F_matrix{2}.om, F_matrix{2}.T', Cam_Para{1}.fc, Cam_Para{1}.cc, Cam_Para{1}.kc, Cam_Para{1}.alpha_c, Cam_Para{3}.fc, Cam_Para{3}.cc, Cam_Para{3}.kc, Cam_Para{3}.alpha_c);
                trajs_3d{obj_mi}.traj{fr - trajs_3d{obj_mi}.bg_frame + 1}.head_pt = XL;
%                 pre_pt{2}.pt = meas{fr}.view{3}.obj{match_idx_s2(obj_mi)}.head_pt(1, 1 : 2)';
%                 pre_pt{2}.pre_fr = fr;
%             else
%                 XL = zeros(3, 1);
%                 XR = zeros(3, 1);
%             end
        end
        
        % back project to each view
        trajs_3d{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame + 1}.view{2}.head_pt_2d = Reproject_to_2D(XL, Cam_Para{2}.kc, Cam_Para{2}.fc, Cam_Para{2}.cc, Cam_Para{2}.alpha_c);
        trajs_3d{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame + 1}.view{3}.head_pt_2d = Reproject_to_2D(XR, Cam_Para{3}.kc, Cam_Para{3}.fc, Cam_Para{3}.cc, Cam_Para{3}.alpha_c);

%         trajs_3d{obj_mi}.traj{fr - trajs_3d{obj_mi}.bg_frame + 1}.head_pt = XL;
    else
%         if match_idx_s2(obj_mi) ~= 0
%             trajs_3d{obj_mi}.traj{fr - trajs_3d{obj_mi}.bg_frame + 1}.view_flag = 2;
%             [XL, XR] = stereo_triangulation(flipud(trajs{obj_mi}.traj{fr - trajs{obj_mi}.bg_frame + 1}.pt(1, 1 : 2)'), meas{fr}.view{3}.obj{match_idx_s2(obj_mi)}.head_pt(1, 1 : 2)', F_matrix{2}.om, F_matrix{2}.T', Cam_Para{1}.fc, Cam_Para{1}.cc, Cam_Para{1}.kc, Cam_Para{1}.alpha_c, Cam_Para{3}.fc, Cam_Para{3}.cc, Cam_Para{3}.kc, Cam_Para{3}.alpha_c);
%         else
            trajs_3d{obj_mi}.traj{fr - trajs_3d{obj_mi}.bg_frame + 1}.view_flag = 3;
%         end
%         trajs_3d{obj_mi}.traj{fr - trajs_3d{obj_mi}.bg_frame + 1}.head_pt = zeros(3, 1);
    end
    
end

end