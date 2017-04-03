function Plot_Traj_3d()

close all;
clear all;
clc;

% global bg_frame;
% global ed_frame;
% global delta_frame;
global trajs_3d;
global F_matrix;
global Cam_Para;

bg_frame = 4500;
ed_frame = 6499;
delta_frame = 1;


% load raw_head_3d_trajs_cv217_S_325-865_Single_Side_View
% load raw_head_3d_trajs_cv217_325-865_Single_Side_View3
% load connected_head_3d_trajs_cv217_325-865_Single_Side_View3
% load connected_head_3d_trajs_cv217_325-865_Single_Side_View3_0523
% load connected_head_3d_trajs_cv217_61-2060_3Views_with_Predict_0528
% load connected_head_3d_trajs_cv217_61-2060_3Views_with_Predict_0807
% load connected_head_3d_trajs_cv213_4500-6499_3Views_with_Predict_0706
% load raw_head_3d_trajs_cv217_61-2060_3Views_with_Predict_0807
% load raw_head_3d_trajs_cv217_61-2060_3Views_with_Predict_0808.mat
% load connected_head_3d_trajs_cv213_4500-6499_3Views_with_Predict_0807

% load connected_head_3d_trajs_cv217_2122-4121_3Views_with_Predict_0906

% load connected_head_3d_trajs_cv217_2122-4121_3Views_with_Predict_0906_smooth2

% load connected_head_3d_trajs_cv217_61-2060_3Views_with_Predict_0811_nosmooth

% load connected_head_3d_trajs_cv217_61-2060_3Views_with_Predict_0811_smooth

load connected_head_3d_trajs_cv213_4500-6499_3Views_with_Predict_0806_smooth


col = colormap(hsv(20));

cnt = zeros(20, 1);
% % Cal_Camera_Para();

figure;
% % axis([-1100 1400 -1100 1400 0 1000])
hold on;
grid on;
view(-20, 10);
% % set(gca,'XTick',-1500:600:1500);
% % set(gca,'YTick',-1500:1000:1500);
% set(gca,'ZTick',0:500:1550);
% % % close all;
% 
% maxx = 0;
% minx = 10000;
% maxy = 0;
% miny = 10000;
% maxz = 0;
% minz = 10000;
for obj = 1 : length(trajs_3d)
    if trajs_3d{obj}.ed_frame == -1
        trajs_3d{obj}.ed_frame = ed_frame;
    end
end

cnt_obj = 0;
% for fr = bg_frame : delta_frame : ed_frame
for obj = 1 : length(trajs_3d)
%     if obj ~= 1 && obj ~= 4 && obj ~= 6 && obj ~= 9 && obj ~= 2
%         continue;
%     end
%     if trajs_3d{obj}.ed_frame == -1
%         trajs_3d{obj}.ed_frame = ed_frame;
%     end
    cnt_obj = cnt_obj + 1;
%     img_ori_M = im2double(imread(['E:/FtpRoot/Dataset/CoreView_217/', 'CoreView_217_Slave2_Camera_', sprintf('%05d', fr), '.bmp']));
%     figure, imshow(img_ori_M);
%     hold on;
%     figure;
% %     % axis([-1000 1000 -1000 1000 8500 9000])
%     hold on;
%     grid on;
%     view(-20, 10);
%     
    pre = -Inf * ones(1, 3);
%     for obj = 1 : length(trajs_3d)
    for fr = trajs_3d{obj}.bg_frame : delta_frame : trajs_3d{obj}.ed_frame
        if fr < trajs_3d{obj}.bg_frame || fr > trajs_3d{obj}.ed_frame
            continue;
        end
        if trajs_3d{obj}.traj{fr - trajs_3d{obj}.bg_frame + 1}.head_pt(1) ~= 0
% %             cnt(obj) = cnt(obj) + 1;
% %             XR2 = Translate_to_Right_View(trajs_3d{obj}.traj{fr - trajs_3d{obj}.bg_frame + 1}.head_pt, F_matrix{2}.om, F_matrix{2}.T);
% %             Xp = Reproject_to_2D(XR2, Cam_Para{3}.kc, Cam_Para{3}.fc, Cam_Para{3}.cc, Cam_Para{3}.alpha_c);
% %             plot(Xp(1, :), Xp(2, :), 'r.');
% %             text(Xp(1, :), Xp(2, :), num2str(obj), 'Color', 'b', 'FontSize', 25);
%             cnt = cnt + 1;
            if pre(1) > -Inf
% % % %                 XR = Translate_to_Right_View(trajs_3d{obj}.traj{fr - trajs_3d{obj}.bg_frame + 1}.head_pt, F_matrix{2}.om, F_matrix{2}.T);
% % % %                 Xp = Reproject_to_2D(XR, Cam_Para{3}.kc, Cam_Para{3}.fc, Cam_Para{3}.cc, Cam_Para{3}.alpha_c);
                delta_dis = sqrt(sum((pre' - trajs_3d{obj}.traj{fr - trajs_3d{obj}.bg_frame + 1}.head_pt).^2));
%                 if delta_dis < 100
%                     XR2 = Translate_to_Right_View(trajs_3d{obj}.traj{fr - trajs_3d{obj}.bg_frame + 1}.head_pt, F_matrix{1}.om, F_matrix{1}.T);
%                     Xp = Reproject_to_2D(XR2, Cam_Para{2}.kc, Cam_Para{2}.fc, Cam_Para{2}.cc, Cam_Para{2}.alpha_c);
% % % %                     plot(trajs_3d{obj}.traj{fr - trajs_3d{obj}.bg_frame + 1}.view{2}.head_pt_2d(1), trajs_3d{obj}.traj{fr - trajs_3d{obj}.bg_frame + 1}.view{2}.head_pt_2d(2), 'r.');
% % % %                     text(Xp(1, :), Xp(2, :), num2str(obj), 'Color', 'b', 'FontSize', 25);

%                     text(Xp(1, :), Xp(2, :), num2str(obj), 'Color', 'b', 'FontSize', 25);
%                     if trajs_3d{obj}.traj{fr - trajs_3d{obj}.bg_frame + 1}.view_flag ==1
                        plot3([pre(1) trajs_3d{obj}.traj{fr - trajs_3d{obj}.bg_frame + 1}.head_pt(1)], [pre(2) trajs_3d{obj}.traj{fr - trajs_3d{obj}.bg_frame + 1}.head_pt(2)], [pre(3) trajs_3d{obj}.traj{fr - trajs_3d{obj}.bg_frame + 1}.head_pt(3)] - 7600, 'Color', col(cnt_obj, :), 'LineWidth', 1);
% % % % % % % % % % % % % % % % %                         plot3([pre(1) trajs_3d{obj}.traj{fr - trajs_3d{obj}.bg_frame + 1}.head_pt(1)], [pre(2) trajs_3d{obj}.traj{fr - trajs_3d{obj}.bg_frame + 1}.head_pt(2)], [pre(3) trajs_3d{obj}.traj{fr - trajs_3d{obj}.bg_frame + 1}.head_pt(3)], 'Color', 'y', 'LineWidth', 3);
%                         plot3(-[pre(1) trajs_3d{obj}.traj{fr - trajs_3d{obj}.bg_frame + 1}.head_pt(1)], [pre(2) trajs_3d{obj}.traj{fr - trajs_3d{obj}.bg_frame + 1}.head_pt(2)], 1500-[pre(3) trajs_3d{obj}.traj{fr - trajs_3d{obj}.bg_frame + 1}.head_pt(3)] + 7600, 'Color', col(cnt_obj, :), 'LineWidth', 1);


%                         if trajs_3d{obj}.traj{fr - trajs_3d{obj}.bg_frame + 1}.fg == 0
%                             plot3(trajs_3d{obj}.traj{fr - trajs_3d{obj}.bg_frame + 1}.head_pt(1), trajs_3d{obj}.traj{fr - trajs_3d{obj}.bg_frame + 1}.head_pt(2), trajs_3d{obj}.traj{fr - trajs_3d{obj}.bg_frame + 1}.head_pt(3), 'r.');
%                         end
%                         if trajs_3d{obj}.traj{fr - trajs_3d{obj}.bg_frame + 1}.fg == 1
%                             plot3(trajs_3d{obj}.traj{fr - trajs_3d{obj}.bg_frame + 1}.head_pt(1), trajs_3d{obj}.traj{fr - trajs_3d{obj}.bg_frame + 1}.head_pt(2), trajs_3d{obj}.traj{fr - trajs_3d{obj}.bg_frame + 1}.head_pt(3), 'g.');
%                         end
%                         if trajs_3d{obj}.traj{fr - trajs_3d{obj}.bg_frame + 1}.fg == 2
%                             plot3(trajs_3d{obj}.traj{fr - trajs_3d{obj}.bg_frame + 1}.head_pt(1), trajs_3d{obj}.traj{fr - trajs_3d{obj}.bg_frame + 1}.head_pt(2), trajs_3d{obj}.traj{fr - trajs_3d{obj}.bg_frame + 1}.head_pt(3), 'b.');
%                         end

%                     plot3(trajs_3d{obj}.traj{fr - trajs_3d{obj}.bg_frame + 1}.head_pt(1), trajs_3d{obj}.traj{fr - trajs_3d{obj}.bg_frame + 1}.head_pt(2), trajs_3d{obj}.traj{fr - trajs_3d{obj}.bg_frame + 1}.head_pt(3), 'r.');
                        
                        
                        
%                     else
%                         plot3([pre(1) trajs_3d{obj}.traj{fr - trajs_3d{obj}.bg_frame + 1}.head_pt(1)], [pre(2) trajs_3d{obj}.traj{fr - trajs_3d{obj}.bg_frame + 1}.head_pt(2)], [pre(3) trajs_3d{obj}.traj{fr - trajs_3d{obj}.bg_frame + 1}.head_pt(3)] - 8050, 'Color', col(obj, :));
%                     end
%                 end
            end
            pre = [trajs_3d{obj}.traj{fr - trajs_3d{obj}.bg_frame + 1}.head_pt(1), trajs_3d{obj}.traj{fr - trajs_3d{obj}.bg_frame + 1}.head_pt(2), trajs_3d{obj}.traj{fr - trajs_3d{obj}.bg_frame + 1}.head_pt(3)];
%             if pre(3) > maxz
%                 maxz = pre(3);
%             end
%             if pre(3) < minz
%                 minz = pre(3);
%             end
%             if pre(2) > maxy
%                 maxy = pre(2);
%             end
%             if pre(2) < miny
%                 miny = pre(2);
%             end
%             if pre(1) > maxx
%                 maxx = pre(1);
%             end
%             if pre(1) < minx
%                 minx = pre(1);
%             end
        end
    end
%     hold off;
%     saveas(gcf, ['./tracking_res_217_slave2_raw/', num2str(fr), '.jpg']);
%     close all;
end

hold off;
sum(cnt) / (2000 * 20)

maxx
maxy
maxz
minx
miny
minz

end