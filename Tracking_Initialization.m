function Tracking_Initialization()

global trajs_3d;
global trajs;
global bg_frame;
global ed_frame;
global delta_frame;

for obj = 1 : length(trajs)
%     if trajs{obj}.bg_frame > bg_frame
%         break;
%     end
    trajs_3d{obj}.bg_frame = bg_frame;
    trajs_3d{obj}.ed_frame = -1;
    trajs_3d{obj}.occ_cnt = 0;
%     trajs_3d{obj}.traj_Master_2d{1}.midline = trajs{obj}.traj{bg_frame - trajs{obj}.bg_frame + 1}.midline;
    trajs_3d{obj}.traj_len = 1;
    trajs_3d{obj}.traj{1}.vel = zeros(3, 1);
    trajs_3d{obj}.traj{1}.head_pt = zeros(3, 1);
%     trajs_3d{obj}.traj{1}.midline = zeros(9, 3);
    trajs_3d{obj}.traj{1}.match_idx_s1 = 0;
    trajs_3d{obj}.traj{1}.match_idx_s2 = 0;
    trajs_3d{obj}.traj{1}.view{1}.head_pt_2d = trajs{obj}.traj{1}.pt(1, 1 : 2)';
    
    
    for j = 1 : (ed_frame - bg_frame + 1) / delta_frame
        trajs_3d{obj}.traj{j}.view{2}.head_pt_2d = -1 * ones(2, 1);
        trajs_3d{obj}.traj{j}.view{3}.head_pt_2d = -1 * ones(2, 1);
    end
%     trajs_3d{obj}.traj{1}.ori = 0; % 2 para?
    
% %     trajs{obj}.traj{1}.scale = meas{bg_frame}.pts(obj, 3);
% %     trajs{obj}.traj{1}.ori = meas{bg_frame}.pts(obj, 4);
end





end