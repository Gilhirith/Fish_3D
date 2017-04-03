function state_update(fr, cst_mtx_idx, asgn, pts)

global cnt_thr;
global n_traj;
global meas;
global trajs;
cnt_thr = 2;

fg = zeros(meas{fr}.view{1}.nobj, 1);

% % state update
for i = 1 : length(asgn)
    if asgn(i) == 0
        trajs{cst_mtx_idx(i)}.cnt = trajs{cst_mtx_idx(i)}.cnt + 1;
        if trajs{cst_mtx_idx(i)}.cnt == cnt_thr
            trajs{cst_mtx_idx(i)}.ed_frame = fr;
        else
            trajs{cst_mtx_idx(i)}.traj_len = trajs{cst_mtx_idx(i)}.traj_len + 1;
            trajs{cst_mtx_idx(i)}.traj{trajs{cst_mtx_idx(i)}.traj_len}.pt = pts(i, 1 : 2);
            trajs{cst_mtx_idx(i)}.traj{trajs{cst_mtx_idx(i)}.traj_len}.scale = 0;
%             trajs{cst_mtx_idx(i)}.traj{trajs{cst_mtx_idx(i)}.traj_len}.midline = [0 0];
        end
    else
        fg(asgn(i)) = 1;
        trajs{cst_mtx_idx(i)}.cnt = 0;
        trajs{cst_mtx_idx(i)}.traj_len = trajs{cst_mtx_idx(i)}.traj_len + 1;
        trajs{cst_mtx_idx(i)}.traj{trajs{cst_mtx_idx(i)}.traj_len}.pt = meas{fr}.view{1}.obj{asgn(i)}.head_pt(1 : 2);
%         trajs{cst_mtx_idx(i)}.traj{trajs{cst_mtx_idx(i)}.traj_len}.scale = meas{fr}.view{1}.obj{asgn(i)}.head_pt(3);
%         trajs{cst_mtx_idx(i)}.traj{trajs{cst_mtx_idx(i)}.traj_len}.midline = meas{fr}.view{1}.obj{asgn(i)}.midline;
    end
end

id = find(fg == 0);

% % add new traj
for i = 1 : length(id)
    n_traj = n_traj + 1;
    trajs{n_traj}.bg_frame = fr;
    trajs{n_traj}.ed_frame = -1;
    trajs{n_traj}.cnt = 0;
    trajs{n_traj}.traj_len = 1;
    trajs{n_traj}.traj{1}.pt = meas{fr}.view{1}.obj{id(i)}.head_pt(1 : 2);
%     trajs{n_traj}.traj{1}.scale = meas{fr}.view{1}.obj{id(i)}.head_pt(3);
%     trajs{n_traj}.traj{1}.midline = meas{fr}.obj{id(i)}.midline;
end

end