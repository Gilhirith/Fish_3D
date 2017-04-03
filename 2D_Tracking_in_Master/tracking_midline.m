function tracking_midline()
    
global bg_frame;
global ed_frame;
global delta_frame;
global meas;
global trajs;
global n_traj;

% % initialize
n_traj = length(meas{bg_frame}.obj);
for i = 1 : length(meas{bg_frame}.obj)
    trajs{i}.bg_frame = bg_frame;
    trajs{i}.ed_frame = -1;
    trajs{i}.cnt = 0;
    trajs{i}.traj_len = 1;
    trajs{i}.traj{1}.pt = meas{bg_frame}.obj{i}.head_pt;
    trajs{i}.traj{1}.midline = meas{bg_frame}.obj{i}.midline;
    trajs{i}.traj{1}.scale = meas{bg_frame}.obj{i}.scale;
end

for fr = bg_frame + delta_frame : delta_frame : ed_frame
    [cst_mtx_idx, pts] = state_predict(fr);
    cst_mtx = cal_cst_mtx(fr, pts);
    [asgn, cst] = Munkres(cst_mtx);
    state_update(fr, cst_mtx_idx, asgn, pts);
end

end