function Traj_Postprocess()

global bg_frame;
global ed_frame;
global delta_frame;
global trajs_3d;

bg_frame =4500;
ed_frame = 6499;
delta_z = 700;
% load raw_head_3d_trajs_cv217_61-2060_3Views_with_Predict_0527
% load raw_head_3d_trajs_cv217_61-2060_Single_Side_View2_0528
% load raw_head_3d_trajs_cv217_61-2060_3Views_with_Predict_0807
% load raw_head_3d_trajs_cv213_4500-6499_3Views_with_Predict_0806

% load raw_head_3d_trajs_cv217_2122-4121_3Views_with_Predict_0906

% load connected_head_3d_trajs_cv217_61-2060_3Views_with_Predict_0811_nosmooth

load raw_head_3d_trajs_cv213_4500-6499_3Views_with_Predict_0806


cnt = zeros(length(trajs_3d), 1);

for i = 1 : length(trajs_3d)
    cnt_n = 0;
    cnt_z = 0;
    for j = bg_frame : ed_frame
        if trajs_3d{i}.traj{j - bg_frame + 1}.head_pt(1) ~= 0
            cnt_z = cnt_z + trajs_3d{i}.traj{j - bg_frame + 1}.head_pt(3);
            cnt_n = cnt_n + 1;
        end
    end
    avg_z = cnt_z / cnt_n;
    for j = bg_frame : ed_frame
        if abs(trajs_3d{i}.traj{j - bg_frame + 1}.head_pt(3) - avg_z) > delta_z
            trajs_3d{i}.traj{j - bg_frame + 1}.head_pt = zeros(3, 1);
        end
    end
end

for i = 1 : length(trajs_3d)
    for j = bg_frame + 1 : ed_frame - 1
        if trajs_3d{i}.traj{j - bg_frame + 1}.head_pt(1) ~= 0
            cnt_fr = 0;
            cnt_z1 = 0;
            for j1 = j - 1 : -1 : bg_frame
                if trajs_3d{i}.traj{j1 - bg_frame + 1}.head_pt(1) ~= 0
                    cnt_fr = cnt_fr + 1;
                    cnt_z1 = cnt_z1 + trajs_3d{i}.traj{j1 - bg_frame + 1}.head_pt(3);
                    if cnt_fr > 8
                        cnt_z1 = cnt_z1 / cnt_fr;
                        break;
                    end
                end
            end
            cnt_fr = 0;
            cnt_z2 = 0;
            for j2 = j + 1 : ed_frame
                if trajs_3d{i}.traj{j2 - bg_frame + 1}.head_pt(1) ~= 0
                    cnt_fr = cnt_fr + 1;
                    cnt_z2 = cnt_z2 + trajs_3d{i}.traj{j2 - bg_frame + 1}.head_pt(3);
                    if cnt_fr > 8
                        cnt_z2 = cnt_z2 / cnt_fr;
                        break;
                    end
                end
            end
%             if trajs_3d{i}.traj{j - bg_frame + 1}.head_pt(3) 
            if j1 < j && j2 > j
                if abs(trajs_3d{i}.traj{j - bg_frame + 1}.head_pt(3) - cnt_z1) > 80 && abs(trajs_3d{i}.traj{j - bg_frame + 1}.head_pt(3) - cnt_z2) > 80
%                     trajs_3d{i}.traj{j - bg_frame + 1}.head_pt = (trajs_3d{i}.traj{j1 - bg_frame + 1}.head_pt + trajs_3d{i}.traj{j2 - bg_frame + 1}.head_pt) / 2;
                    trajs_3d{i}.traj{j - bg_frame + 1}.head_pt = zeros(3, 1);
                end
% %                 if trajs_3d{i}.traj{j - bg_frame + 1}.head_pt(3) < 7600 || trajs_3d{i}.traj{j - bg_frame + 1}.head_pt(3) > 9050% && norm(trajs_3d{i}.traj{j - bg_frame + 1}.head_pt - trajs_3d{i}.traj{j2 - bg_frame + 1}.head_pt) > 200
% % %                     trajs_3d{i}.traj{j - bg_frame + 1}.head_pt = (trajs_3d{i}.traj{j1 - bg_frame + 1}.head_pt + trajs_3d{i}.traj{j2 - bg_frame + 1}.head_pt) / 2;
% %                     trajs_3d{i}.traj{j - bg_frame + 1}.head_pt = zeros(3, 1);
% %                 end
            end
        end
    end
end


for i = 1 : length(trajs_3d)
    i
    j = bg_frame;
    while j <= ed_frame;
        j
        trajs_3d{i}.traj{j - bg_frame + 1}.fg = 0;
        if trajs_3d{i}.traj{j - bg_frame + 1}.head_pt(1) == 0
            if j > bg_frame
                tp_j = j;
                while tp_j <= ed_frame
                    if trajs_3d{i}.traj{tp_j - bg_frame + 1}.head_pt(1) == 0
                        trajs_3d{i}.traj{tp_j - bg_frame + 1}.fg = 1;
                        tp_j = tp_j + 1;
                    else
                        break;
                    end
                end
                if tp_j <= ed_frame
                    delta_pt = (trajs_3d{i}.traj{tp_j - bg_frame + 1}.head_pt - trajs_3d{i}.traj{j - bg_frame}.head_pt) / (tp_j - j + 1);
                    for tpp_j = j : tp_j - 1
                        cnt(i) = cnt(i) + 1;
                        trajs_3d{i}.traj{tpp_j - bg_frame + 1}.fg = 2;
                        trajs_3d{i}.traj{tpp_j - bg_frame + 1}.head_pt = trajs_3d{i}.traj{tpp_j - bg_frame}.head_pt + delta_pt;
                    end
                end
                j = tp_j;
            else
                while j <= ed_frame
%                     j
                    if trajs_3d{i}.traj{j - bg_frame + 1}.head_pt(1) == 0
                        j = j + 1;
                    else
                        break;
                    end
                end
            end
        else
            j = j + 1;
            
        end
    end
    
end

% for itr = 1 : 30
%     Smooth_Traj_3D(3);
%     for i = 1 : length(trajs_3d)
%         for j = bg_frame : ed_frame
%             if trajs_3d{i}.traj{j - bg_frame + 1}.head_pt(1) ~= 0
%                 trajs_3d{i}.traj{j - bg_frame + 1}.head_pt = trajs_3d{i}.traj{j - bg_frame + 1}.smoothed_head_pt;
%             end
%         end
%     end
% end
% 
% for itr = 1 : 30
%     Smooth_Traj_3D(2);
%     for i = 1 : length(trajs_3d)
%         for j = bg_frame : ed_frame
%             if trajs_3d{i}.traj{j - bg_frame + 1}.head_pt(1) ~= 0
%                 trajs_3d{i}.traj{j - bg_frame + 1}.head_pt = trajs_3d{i}.traj{j - bg_frame + 1}.smoothed_head_pt;
%             end
%         end
%     end
% end

for delta = 8 : -1 : 1
    for itr = 1 : 10
        Smooth_Traj_3D(delta);
        for i = 1 : length(trajs_3d)
            for j = bg_frame : ed_frame
                if trajs_3d{i}.traj{j - bg_frame + 1}.head_pt(1) ~= 0
                    trajs_3d{i}.traj{j - bg_frame + 1}.head_pt = trajs_3d{i}.traj{j - bg_frame + 1}.smoothed_head_pt;
                end
            end
        end
    end
end


% for delta = 1 : 5
%     for itr = 1 : 15
%         Smooth_Traj_3D(delta);
%         for i = 1 : length(trajs_3d)
%             for j = bg_frame : ed_frame
%                 if trajs_3d{i}.traj{j - bg_frame + 1}.head_pt(1) ~= 0
%                     trajs_3d{i}.traj{j - bg_frame + 1}.head_pt = trajs_3d{i}.traj{j - bg_frame + 1}.smoothed_head_pt;
%                 end
%             end
%         end
%     end
% end




for i = 1 : length(trajs_3d)
    for j = bg_frame : ed_frame
        if trajs_3d{i}.traj{j - bg_frame + 1}.head_pt(1) ~= 0
            trajs_3d{i}.bg_frame = j;
            break;
        end
    end
    for j = ed_frame : -1 : bg_frame
        if trajs_3d{i}.traj{j - bg_frame + 1}.head_pt(1) ~= 0
            trajs_3d{i}.ed_frame = j;
            break;
        end
    end
end

for i = 1 : length(trajs_3d)
    for j = trajs_3d{i}.bg_frame + 1 : trajs_3d{i}.ed_frame
        trajs_3d{i}.traj{j - bg_frame + 1}.vel = trajs_3d{i}.traj{j - bg_frame + 1}.head_pt - trajs_3d{i}.traj{j - bg_frame}.head_pt;
        if j >= trajs_3d{i}.bg_frame + 2
            trajs_3d{i}.delta_vel(1 : 3, j - bg_frame + 1) = trajs_3d{i}.traj{j - bg_frame + 1}.vel - trajs_3d{i}.traj{j - bg_frame}.vel;
        end
    end
end

save('connected_head_3d_trajs_cv213_4500-6499_3Views_with_Predict_0806_smooth.mat', 'trajs_3d')
end