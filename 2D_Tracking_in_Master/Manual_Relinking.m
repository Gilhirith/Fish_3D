close all;
clear all;
clc;

bg_frame = 2122;
ed_frame = 4121;
nfish = 10;

% load raw_trajs_CV217_61-2060
% load('raw_trajs_CV213_4500-7500.mat');
load connected_trajs_CV217_2122-4121_vel40;

fid = fopen('manual_relink_217_2122-4121.txt', 'r');

trajs1 = trajs;

while true
    st = fscanf(fid, '%d', [1 1]);
    if feof(fid)
        break;
    end
    tp = fscanf(fid, '%d %d', [1 2]);
    for fr = min(max(tp(2), trajs1{tp(1)}.bg_frame), trajs1{st}.ed_frame) : ed_frame
        trajs{st}.traj{fr - trajs1{st}.bg_frame + 1}.pt = [0 0];
    end
    while true
        if trajs1{tp(1)}.ed_frame == -1
            trajs1{tp(1)}.ed_frame = ed_frame + 1;
        end
        tp2 = tp;
        tp = fscanf(fid, '%d %d', [1 2]);
        if tp(1) ~= -1
            for fr = max(tp2(2), trajs1{tp2(1)}.bg_frame) : min(max(tp(2) - 1, trajs1{tp(1)}.bg_frame), trajs1{tp2(1)}.ed_frame - 1)
                trajs{st}.traj{fr - trajs1{st}.bg_frame + 1}.pt = trajs1{tp2(1)}.traj{fr - trajs1{tp2(1)}.bg_frame + 1}.pt;
            end
        else
            for fr = max(tp2(2), trajs1{tp2(1)}.bg_frame) : trajs1{tp2(1)}.ed_frame - 1
                trajs{st}.traj{fr - trajs1{st}.bg_frame + 1}.pt = trajs1{tp2(1)}.traj{fr - trajs1{tp2(1)}.bg_frame + 1}.pt;
            end
        end
        
        if tp(1) == -1
            break;
        end
    end
end

clear trajs1;

for i = 1 : nfish + 1
    if i < nfish
        trajs1{i} = trajs{i};
    end
    if i > nfish
        trajs1{i - 1} = trajs{i};
    end
end

clear trajs;

for i = 1 : nfish
    trajs{i} = trajs1{i};
    for fr = ed_frame : -1 : bg_frame
        if trajs{i}.traj{fr - trajs{i}.bg_frame + 1}.pt(1) ~= 0
            break;
        end
    end
    trajs{i}.ed_frame = fr + 1;
    fr
end

for i = 1 : nfish
    fr = trajs{i}.bg_frame;
    while fr <= trajs{i}.ed_frame - 1
%         fr
        if trajs{i}.traj{fr - trajs{i}.bg_frame + 1}.pt(1) == 0
            for ffr = fr : trajs{i}.ed_frame - 1
                if trajs{i}.traj{ffr - trajs{i}.bg_frame + 1}.pt(1) ~= 0
                    break;
                end
            end
            delta_pos = (trajs{i}.traj{ffr - trajs{i}.bg_frame + 1}.pt - trajs{i}.traj{fr - trajs{i}.bg_frame }.pt) / (ffr - fr + 1);
            for fffr = fr : ffr - 1;
                trajs{i}.traj{fffr - trajs{i}.bg_frame + 1}.pt = trajs{i}.traj{fffr - trajs{i}.bg_frame}.pt + delta_pos;
            end
            fr = ffr - 1;
        end
        fr = fr + 1;
    end
end

save('manual_relinked_CV217_2122-4121.mat', 'trajs');