close all;
clear all;
clc;




aviobj = avifile('res_CoreView54_1-300/CoreView_10.avi', 'compression', 'None', 'quality', 100);

load('trajs_fish10_CoreView10_1-300_final.mat', 'trajs');
delta = 1;
col = colormap(jet(10));
r = randperm(size(col, 1));
col = col(r, :);
for i = 1 : 1 : 300
    read_image = imshow(imread(['../Fish_2D_CNN/CoreView_10/CoreView_10_Master_Camera_', sprintf('%04d', i), '.bmp']));
    hold on;
    text(0, 2000, '10 fish', 'Color', 'r', 'FontSize', 20);
    for j = 1 : 10
        for k = max(i - 18 * delta, 1 + delta) : delta : i
            plot([trajs{j}.traj{k - delta}.pt(2), trajs{j}.traj{k}.pt(2)], [trajs{j}.traj{k - delta}.pt(1), trajs{j}.traj{k}.pt(1)], 'LineStyle', ':', 'Color', col(j, :), 'LineWidth', 3);
        end
    end
    for j = 1 : 10
        text(trajs{j}.traj{i}.pt(2), trajs{j}.traj{i}.pt(1), num2str(j), 'Color', 'r', 'FontSize', 15);
    end
    F = getframe;
    aviobj = addframe(aviobj, F);
%     saveas(gcf, ['res_CoreView54_1-300/test_', sprintf('%04d', i), '.jpg']);
    close all;
end

aviobj = close(aviobj);

clear trajs;

load('trajs_fish20_CoreView54_1-500_final.mat', 'trajs');
delta = 2;
col = colormap(jet(20));
r = randperm(size(col, 1));
col = col(r, :);
for i = 1 : delta : 300
    read_image = imshow(imread(['../Fish_2D_CNN/CoreView_54/CoreView_54_Master_Camera_', sprintf('%05d', i), '.bmp']));
    hold on;
    text(0, 2000, '20 fish', 'Color', 'r', 'FontSize', 20);
    for j = 1 : 20
        for k = max(i - 25 * delta, 1 + delta) : delta : i
            plot([trajs{j}.traj{k - delta}.pt(2), trajs{j}.traj{k}.pt(2)], [trajs{j}.traj{k - delta}.pt(1), trajs{j}.traj{k}.pt(1)], 'Color', col(j, :), 'LineWidth', 3);
        end
    end
    for j = 1 : 20
        text(trajs{j}.traj{i}.pt(2), trajs{j}.traj{i}.pt(1), num2str(j), 'Color', 'r', 'FontSize', 15);
    end
    F = getframe;
    aviobj = addframe(aviobj, F);
%     saveas(gcf, ['res_CoreView54_1-300/test_', sprintf('%04d', i), '.jpg']);
    close all;
end

clear trajs;

load('trajs_fish49_CoreView241_222-521_final.mat', 'trajs');
delta = 1;
col = colormap(jet(49));
r = randperm(size(col, 1));
col = col(r, :);
for i = 222 : 1 : 521
    read_image = imshow(imread(['../Fish_2D_CNN/CoreView_241/CoreView_241_Master_Camera_', sprintf('%05d', i), '.bmp']));
    hold on;
    text(0, 2000, '49 fish', 'Color', 'r', 'FontSize', 20);
    for j = 1 : 49
        for k = max(i - 20 * delta - 221, 1 + delta) : delta : i - 221
            plot([trajs{j}.traj{k - delta}.pt(2), trajs{j}.traj{k}.pt(2)], [trajs{j}.traj{k - delta}.pt(1), trajs{j}.traj{k}.pt(1)], 'Color', col(j, :), 'LineWidth', 3);
        end
    end
    for j = 1 : 49
        text(trajs{j}.traj{i - 221}.pt(2), trajs{j}.traj{i - 221}.pt(1), num2str(j), 'Color', 'r', 'FontSize', 15);
    end
    F = getframe;
    aviobj = addframe(aviobj, F);
%     saveas(gcf, ['res_CoreView54_1-300/test_', sprintf('%04d', i), '.jpg']);
    close all;
end

aviobj = close(aviobj);