function DoH_Midline_Association()

global trajs;

bg_frame = 325;
ed_frame = 865;
delta_frame = 1;

load complete_trajs_CV217_325-865.mat
load meas_cv217_M_61-1060_Midline_step1

for fr = bg_frame : delta_frame : ed_frame
    fr
    img = im2double(imread(['E:/FtpRoot/Dataset/CoreView_217/CoreView_217_Master_Camera_', sprintf('%05d', fr), '.bmp']));
    figure,imshow(img);
    hold on;
    for i = 1 : 10
        pt = trajs{i}.traj{fr - trajs{i}.bg_frame + 1}.pt;
        plot(pt(2), pt(1), 'b.');
        text(pt(2), pt(1), num2str(i), 'Color', 'g', 'FontSize', 20);
        clear dis;
        for j = 1 : meas{fr}.nobj
            pt2 = meas{fr}.obj{j}.midline(1, :);
            pt2 = fliplr(pt2);
%             plot(pt2(2), pt2(1), 'b.');
            dis(j) = sqrt(sum((pt-pt2).^2));
        end
        [mind midinx] = min(dis);
        pt3 = meas{fr}.obj{midinx}.midline(1, :);
        pt3 = fliplr(pt3);
        pt4 = meas{fr}.obj{midinx}.midline(end, :);
        pt4 = fliplr(pt4);
        tp_dis1 = sqrt(sum((pt-pt3).^2));
        tp_dis2 = sqrt(sum((pt-pt4).^2));
        if tp_dis1 > tp_dis2
            meas{fr}.obj{midinx}.midline = flipud(meas{fr}.obj{midinx}.midline);
        end
        if min(tp_dis1, tp_dis2) < 35
            trajs{i}.traj{fr - trajs{i}.bg_frame + 1}.midline = meas{fr}.obj{midinx}.midline;
        else
            trajs{i}.traj{fr - trajs{i}.bg_frame + 1}.midline = zeros(9, 2);
        end
        if min(trajs{i}.traj{fr - trajs{i}.bg_frame + 1}.midline(:)) > 0
            plot(trajs{i}.traj{fr - trajs{i}.bg_frame + 1}.midline(:, 1), trajs{i}.traj{fr - trajs{i}.bg_frame + 1}.midline(:, 2), 'r.');
        end
%         plot(trajs{i}.traj{fr - trajs{i}.bg_frame + 1}.midline(1, 1), trajs{i}.traj{fr - trajs{i}.bg_frame + 1}.midline(1, 2), 'b.');
%         text(trajs{i}.traj{fr - trajs{i}.bg_frame + 1}.midline(1, 1), trajs{i}.traj{fr - trajs{i}.bg_frame + 1}.midline(1, 2), num2str(midinx), 'Color', 'g', 'FontSize', 20);
    end
    saveas(gcf, ['midline_res_CoreView217_325-865/', sprintf('%04d', fr), '.jpg']);
    close all;
    tic;
end




save('midline_trajs_CV217_325-865.mat', 'trajs');


end