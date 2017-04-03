clear all;
% load('raw_trajs_CV340_1-2000_thr2.mat');
load('raw_trajs_CV340_1-2000_thr2.mat');
% load raw_trajs_CV217_2122-4121_radius50;

close all;

ntraj = length(trajs);
vel = 80;

for i = 1 : ntraj
    if trajs{i}.ed_frame == -1
        trajs{i}.ed_frame = 2001;
    end
end

cst_mtx = Inf * ones(ntraj, ntraj);

for i = 1 : ntraj
%     if length(trajs{i}.traj) < 10
%         continue;
%     end
    for j = 1 : ntraj
%         if length(trajs{j}.traj) < 10
%             continue;
%         end
        if trajs{i}.ed_frame <= trajs{j}.bg_frame + 1
            df = trajs{j}.bg_frame - trajs{i}.ed_frame + 1;
            dis = sqrt(sum((trajs{i}.traj{end}.pt - trajs{j}.traj{1}.pt).^2, 2));
            if dis < abs(df * vel) && df < 10
                cst_mtx(i, j) = dis;%sqrt(df.^2 + dis.^2);
            end
        end
    end
end

[asgn, cst] = Munkres(cst_mtx);

fg = zeros(ntraj, 1);
for i = 1 : ntraj
    trajs{i}.relink = i;
    trajs{i}.id = i;
end
cnt = 0;
for i = 1 : ntraj
    i
    if fg(i) == 1 || asgn(i) == 0
        continue;
    end
    tp = asgn(i);
    cnt = cnt + 1;
    while tp ~= 0 && fg(tp) ~= 1
        fg(tp) = 1;
        trajs{i}.relink = [trajs{i}.relink tp];
        trajs{tp}.id = i;
        tp = asgn(tp);
    end
end

rng(0);
col = colormap(hsv(160));
r = randperm(size(col, 1));
col = col(r, :);
    
figure;
hold on;
grid on;
view(-20, 10);
    
fg = zeros(ntraj, 1);
tp = 1;
for i = 1 : ntraj
    if fg(i) == 1
        continue;
    end
    len = 0;
    fst = trajs{i}.bg_frame;
    for j = 1 : length(trajs{i}.relink)
        fg(trajs{i}.relink(j)) = 1;
        len = len + length(trajs{trajs{i}.relink(j)}.traj);
        lst = trajs{trajs{i}.relink(j)}.ed_frame;
    end
    if len < 100 && (lst < 2001 && fst > 1)
        continue;
    end
%     figure;
%     hold on;
%     grid on;
%     view(-20, 10);
%     if tp ~= 3
%     text(trajs{i}.traj{1}.pt(2), trajs{i}.traj{1}.pt(1), trajs{i}.bg_frame - 221, num2str(i), 'Color', 'b', 'FontSize',12);
    clear tp_traj;
    tp_traj(1, 1 : 2) = trajs{trajs{i}.relink(1)}.traj{1}.pt;
    tp_traj(1, 3) = trajs{trajs{i}.relink(1)}.bg_frame + 1;
    cnt_t = 1;
    trajs1{tp}.traj{cnt_t}.pt = trajs{trajs{i}.relink(1)}.traj{1}.pt;
    trajs1{tp}.bg_frame = trajs{trajs{i}.relink(1)}.bg_frame;
    for j = 1 : length(trajs{i}.relink)
        fg(trajs{i}.relink(j)) = 1;
        if j > 1
            for k = length(trajs1{tp}.traj) + 1 : trajs{trajs{i}.relink(j)}.bg_frame - trajs1{tp}.bg_frame
                trajs1{tp}.traj{k}.pt = zeros(1, 2);
            end
            cnt_t = cnt_t + 1;
            tp_traj(end + 1, 1 : 2) = trajs{trajs{i}.relink(j)}.traj{1}.pt;
            tp_traj(end, 3) = trajs{trajs{i}.relink(j)}.bg_frame + 1;
            trajs1{tp}.traj{trajs{trajs{i}.relink(j)}.bg_frame - trajs1{tp}.bg_frame + 1}.pt = trajs{trajs{i}.relink(j)}.traj{1}.pt;
        end
        for k = 2 : length(trajs{trajs{i}.relink(j)}.traj)
            tp_traj(end + 1, 1 : 2) = trajs{trajs{i}.relink(j)}.traj{k}.pt;
            tp_traj(end, 3) = trajs{trajs{i}.relink(j)}.bg_frame + k;
            cnt_t = cnt_t + 1;
            trajs1{tp}.traj{trajs{trajs{i}.relink(j)}.bg_frame + k - trajs1{tp}.bg_frame}.pt = trajs{trajs{i}.relink(j)}.traj{k}.pt;
%             trajs{trajs{i}.relink(j)}.traj{k}.pt
%             trajs{trajs{i}.relink(j)}.traj{k - 1}.pt
%             trajs{trajs{i}.relink(j)}.bg_frame
            plot3(2000 - [trajs{trajs{i}.relink(j)}.traj{k}.pt(2), trajs{trajs{i}.relink(j)}.traj{k - 1}.pt(2)], 2000-[trajs{trajs{i}.relink(j)}.traj{k}.pt(1), trajs{trajs{i}.relink(j)}.traj{k - 1}.pt(1)], [trajs{trajs{i}.relink(j)}.bg_frame + k, trajs{trajs{i}.relink(j)}.bg_frame + k - 1] - 0, '-', 'Color', col(tp, :), 'LineWidth', 1);
        end
        if j < length(trajs{i}.relink)
            plot3(2000 - [trajs{trajs{i}.relink(j)}.traj{length(trajs{trajs{i}.relink(j)}.traj)}.pt(2), trajs{trajs{i}.relink(j + 1)}.traj{1}.pt(2)], 2000-[trajs{trajs{i}.relink(j)}.traj{length(trajs{trajs{i}.relink(j)}.traj)}.pt(1), trajs{trajs{i}.relink(j + 1)}.traj{1}.pt(1)], [trajs{trajs{i}.relink(j)}.bg_frame + length(trajs{trajs{i}.relink(j)}.traj), trajs{trajs{i}.relink(j + 1)}.bg_frame] - 0, '-', 'Color', col(tp, :), 'LineWidth', 1);
        end
    end
%     end
% % % % %     tp_traj(:, 1 : 2) = Smooth_2D(tp_traj(:, 1 : 2));
% % % % %     tp_traj(:, 1 : 2) = Smooth_2D(tp_traj(:, 1 : 2));
% % % % %     tp_traj(:, 1 : 2) = Smooth_2D(tp_traj(:, 1 : 2));
% % % % %     tp_traj(:, 1 : 2) = Smooth_2D(tp_traj(:, 1 : 2));
% % % % %     tp_traj(:, 1 : 2) = Smooth_2D(tp_traj(:, 1 : 2));
% % % % %     tp_traj(:, 1 : 2) = Smooth_2D(tp_traj(:, 1 : 2));
% % % % %     tp_traj(:, 1 : 2) = Smooth_2D(tp_traj(:, 1 : 2));
% % % % %     tp_traj(:, 1 : 2) = Smooth_2D(tp_traj(:, 1 : 2));
% % % % %     plot3(tp_traj(:, 2), tp_traj(:, 1), tp_traj(:, 3) - 0, '-', 'Color', col(tp, :), 'LineWidth', 1);
%     trajs1{tp}.bg_frame = trajs1{tp}.traj{1}.fr;
    trajs1{tp}.ed_frame = trajs1{tp}.bg_frame + length(trajs1{tp}.traj);
    tp = tp + 1;
%     hold off;
%     close all;
%     text(trajs{trajs{i}.relink(end)}.traj{end}.pt(2), trajs{trajs{i}.relink(end)}.traj{end}.pt(1), trajs{trajs{i}.relink(end)}.ed_frame - 1 - 221, num2str(i), 'Color', 'k', 'FontSize',12);
end

tp
clear trajs;
trajs = trajs1;

% save('connected_trajs_CV217_2122-4121_vel40.mat', 'trajs');
% save('connected_trajs_CV217_2122-4121_radius50.mat', 'trajs');
% view(-20, 10);
% axis ([0 2000 0 2000 0 2000]);
% set (gcf,'Position',[100, 100, 600, 600]);