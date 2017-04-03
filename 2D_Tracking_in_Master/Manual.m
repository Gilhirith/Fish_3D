% % % function Manual_Mark()
% % 
% % close all;
% % clear all;
% % clc;
% % 
% % global sample_bg_frame;
% % global sample_ed_frame;
% % global sample_delta_frame;
% % global nfish;
% % 
% % nfish = 1;
% % sample_bg_frame = 1;
% % sample_ed_frame = 599;
% % sample_delta_frame = 2;
% % 
% % % manually mark a single fish in all frmaes
% % for fish = 27 : 27
% % %     clear x;
% %     t = 1;
% %     for fr = 1 : sample_delta_frame : sample_ed_frame
% %         fr
% %         img_original = im2double(imread(['fish_27/CoreView_340_Flare_4M180_NCL_(2)_', sprintf('%05d', fr), '.bmp']));
% % %         img_original = im2double(imread(['CoreView_257\\CoreView_257_Master_Camera_', sprintf('%04d', fr), '.bmp']));
% %         figure, imshow(img_original);
% %         set(gcf,'outerposition',get(0,'screensize'));
% %         [x(fr, 1), x(fr, 2)] = ginput;
% %         close all;
% %         t = t + 1;
% %     end
% %     save(['fish_340_', num2str(fish), '_', num2str(1), '-', num2str(sample_ed_frame), '.mat'], 'x');
% % end


% load fish_340_18_593-599;
% tp_x = x;
% clear x;
% load fish_340_18_557-591;
% for i = 593 : 2 : 599
%     x(i, :) = tp_x(i, :);
% end
% clear tp_x;
% tp_x = x;
% load fish_340_18_1-555;
% for i = 557 : 2 : 599
%     x(i, :) = tp_x(i, :);
% end
% save('fish_340_18_1-599.mat', 'x');

% load('../meas_cv340_DoH_M_1-2000_Midline_step1.mat');

for obj = 1 : 27
    load(['./manual_res_340/fish_340_', num2str(obj), '_1-599.mat']);
    trajs{obj}.manual_traj = x;
end

for i = 1 : 2 : 599
    cst_mtx = Inf * ones(27, meas{i}.view{1}.nobj);
    for j = 1 : 27
        for k = 1 : meas{i}.view{1}.nobj
            cst_mtx(j, k) = norm(trajs{j}.manual_traj(i, :) - fliplr(meas{i}.view{1}.obj{k}.head_pt(1 : 2)));
            if cst_mtx(j, k) > 30
                cst_mtx(j, k) = Inf;
            end
        end
    end
    [asgn, cst] = Munkres(cst_mtx);
%     img_original = im2double(imread(['E:/FtpRoot/Dataset/20160617/27_Stone/CoreView_340_Flare_4M180_NCL_(2)_', sprintf('%05d', i), '.bmp']));
%     figure, imshow(img_original);
%     hold on;
%     set(gcf,'outerposition',get(0,'screensize'));
    for j = 1 : length(asgn)
        if asgn(j) ~= 0
            trajs{j}.traj{i} = meas{i}.view{1}.obj{asgn(j)};
        else
            trajs{j}.traj{i}.head_pt = fliplr(trajs{j}.manual_traj(i, :));
            trajs{j}.traj{i}.phi = 0;
        end
%         plot(trajs{j}.traj{i}.pt(2), trajs{j}.traj{i}.pt(1), 'r.');
%         text(trajs{j}.traj{i}.pt(2), trajs{j}.traj{i}.pt(1), num2str(j), 'Color', 'b', 'FontSize', 20);
    end
%     saveas(gcf, ['res_CoreView340_1-2000_step2_2/', sprintf('%04d', i), '.jpg']);
%     hold off;
%     close all;
end


save('trajs_fish27_CoreView340_1-599_step2_final.mat', 'trajs')