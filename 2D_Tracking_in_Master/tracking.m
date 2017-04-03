function tracking()
    
global bg_frame;
global ed_frame;
global delta_frame;
global meas;
global trajs;
global n_traj;

% % initialize
n_traj = meas{bg_frame}.view{1}.nobj;
for obj = 1 : n_traj
    trajs{obj}.bg_frame = bg_frame;
    trajs{obj}.ed_frame = -1;
    trajs{obj}.cnt = 0;
    trajs{obj}.traj_len = 1;
    trajs{obj}.traj{1}.pt = meas{bg_frame}.view{1}.obj{obj}.head_pt(1, 1 : 2);
%     trajs{obj}.traj{1}.midline = meas{bg_frame}.view{1}.obj{obj}.midline;
% %     trajs{obj}.traj{1}.scale = meas{bg_frame}.pts(obj, 3);
%     trajs{obj}.traj{1}.ori = meas{bg_frame}.view{1}.obj{obj}.ori;
end

for fr = bg_frame + delta_frame : delta_frame : ed_frame
    fr
    [cst_mtx_idx, pts] = state_predict(fr);
    cst_mtx = cal_cst_mtx(fr, pts);
    [asgn, cst] = Munkres(cst_mtx);
    state_update(fr, cst_mtx_idx, asgn, pts);
end

end