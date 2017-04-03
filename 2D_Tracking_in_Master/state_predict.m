function [cst_mtx_idx, pts_predict] = state_predict(fr)

global trajs;
global bg_frame;
global ed_frame;
global delta_frame;

n_obj = 0;

for i = 1 : length(trajs)
    if trajs{i}.ed_frame == -1
        n_obj = n_obj + 1;
        cst_mtx_idx(n_obj) = i;
    end
end

pts_predict = zeros(length(cst_mtx_idx), 3);

for i = 1 : length(cst_mtx_idx)
    if trajs{cst_mtx_idx(i)}.ed_frame > 0
        continue;
    end
    t = (fr - trajs{cst_mtx_idx(i)}.bg_frame) / delta_frame + 1;
    if t > 2
        pts_predict(i, 1 : 2) = 2 * trajs{cst_mtx_idx(i)}.traj{t - 1}.pt - trajs{cst_mtx_idx(i)}.traj{t - 2}.pt;
%         pts_predict(i, 3) = 2 * trajs{cst_mtx_idx(i)}.traj{t - 1}.ori - trajs{cst_mtx_idx(i)}.traj{t - 2}.ori;
    else
        pts_predict(i, 1 : 2) = trajs{cst_mtx_idx(i)}.traj{t - 1}.pt;
%         pts_predict(i, 3) = trajs{cst_mtx_idx(i)}.traj{t - 1}.ori;
    end
end

end