function Smooth_Traj_3D(delta)

global trajs_3d;
global bg_frame;
global ed_frame;

% bg_frame = 325;

for i = 1 : length(trajs_3d)
    j = bg_frame;
    while trajs_3d{i}.traj{j - bg_frame + 1}.head_pt(1) == 0
        j = j + 1;
    end

    k = ed_frame;
    while trajs_3d{i}.traj{k - bg_frame + 1}.head_pt(1) == 0
        k = k - 1;
    end

    for h = 1 : delta
        trajs_3d{i}.traj{j - bg_frame + h}.smoothed_head_pt = trajs_3d{i}.traj{j - bg_frame + h}.head_pt;
        trajs_3d{i}.traj{j - bg_frame + h}.smoothed_head_pt = trajs_3d{i}.traj{j - bg_frame + h}.head_pt;
    end
    for h = 1 : delta
        trajs_3d{i}.traj{k - bg_frame + 2 - h}.smoothed_head_pt = trajs_3d{i}.traj{k - bg_frame + 2 - h}.head_pt;
        trajs_3d{i}.traj{k - bg_frame + 2 - h}.smoothed_head_pt = trajs_3d{i}.traj{k - bg_frame + 2 - h}.head_pt;
    end
    for jj = j + delta : k - delta
        tp_val = zeros(size(trajs_3d{i}.traj{k - bg_frame + 1}.head_pt));
        for kk = 1 : delta
            i1 = jj - kk;
            i2 = jj + kk;
            tp_val = tp_val + trajs_3d{i}.traj{i1 - bg_frame + 1}.head_pt + trajs_3d{i}.traj{i2 - bg_frame + 1}.head_pt;
        end
        trajs_3d{i}.traj{jj - bg_frame + 1}.smoothed_head_pt = tp_val / (2 * delta);
% %         i1 = jj - delta;
% % %         if i1 < bg_frame
% % %             i1 = i1 + n;
% % %         end
% %         i2 = jj + delta;
% % %         if i2 > ed_frame
% % %             i2 = i2 - n;
% % %         end
% %         i1
% %         i2
% %         trajs_3d{i}.traj{jj - bg_frame + 1}.smoothed_head_pt = (trajs_3d{i}.traj{i1 - bg_frame + 1}.head_pt + trajs_3d{i}.traj{i2 - bg_frame + 1}.head_pt) / 2;
    end

end

% for k = 1 : m
%     b(1, :) = (69 * a(1, :) + 4 * (a(2, :) + a(4, :)) - 6 * a(3, :) - a(5, :)) / 70;
%     b(2, :) = (2 * (a(1, :) + a(5, :)) + 27 * a(2, :) + 12 * a(3, :) - 8 * a(4, :)) / 35;
%     for j = 3 : n - 2
%         b(j, :) = (-3 * (a(j - 2) + a(j + 2, :)) + 12 * (a(j - 1, :) + a(j + 1, :)) + 17 * a(j, :)) / 35;
%     end
%     b(n - 1, :) = (2 * (a(n, :) + a(n - 4, :)) + 27 * a(n - 1, :) + 12 * a(n - 2, :) - 8 * a(n - 3, :)) / 35;
%     b(n, :) = (69 * a(n, :) + 4 * (a(n - 1, :) + a(n - 3, :)) - 6 * a(n - 2, :) - a(n - 4, :)) / 70;
%     a = b;
% end
% 
% y = a;

end