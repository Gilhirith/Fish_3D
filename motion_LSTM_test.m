function motion_LSTM_test

close all;
clear all;
clc;

global nfish;
global bg_frame;
global ed_frame;
global delta_frame;
global trajs_3d;
global problem_motion;
global fr;

addpath(genpath('./LSTM-MATLAB-master/'));

nfish = 10;
bg_frame = 325;
ed_frame = 865;
delta_frame = 1;
test_len = 5;

load connected_head_3d_trajs_cv217_325-865_Single_Side_View3
load LSTM_train_motion_delta_vel_0510

figure;
hold on;

i = 10;
for fr = trajs_3d{i}.bg_frame + test_len - 1 : trajs_3d{i}.ed_frame - 1
    tic;
    fr
    plot3([trajs_3d{i}.traj{fr - bg_frame + 2}.head_pt(1) trajs_3d{i}.traj{fr - bg_frame + 1}.head_pt(1)], [trajs_3d{i}.traj{fr - bg_frame + 2}.head_pt(2) trajs_3d{i}.traj{fr - bg_frame + 1}.head_pt(2)], [trajs_3d{i}.traj{fr - bg_frame + 2}.head_pt(3) trajs_3d{i}.traj{fr - bg_frame + 1}.head_pt(3)], 'b-');
    toc;
end

for fr = trajs_3d{i}.bg_frame + 2 : trajs_3d{i}.ed_frame - test_len + 1
    tic;
    fr
    for ffr = fr : fr + test_len - 1
        tp_delta_vel(1 : 3, ffr - fr + 1) = trajs_3d{i}.delta_vel(1 : 3, ffr - bg_frame + 1);
        tp_vel(1 : 3, ffr - fr + 1) = trajs_3d{i}.traj{ffr - bg_frame + 1}.vel;
        tp_head_pt(1 : 3, ffr - fr + 1) = trajs_3d{i}.traj{ffr - bg_frame + 1}.head_pt;
    end
    for itr = 1 : test_len - 1
        motion_predict = motion_predict_LSTM(fr);
        trajs_3d{i}.delta_vel(1 : 3, fr - bg_frame + 1) = motion_predict(i, :)';
        trajs_3d{i}.traj{fr - bg_frame + 1}.vel = trajs_3d{i}.traj{fr - bg_frame}.vel + motion_predict(i, :)';
        trajs_3d{i}.traj{fr - bg_frame + 1}.head_pt = trajs_3d{i}.traj{fr - bg_frame}.head_pt + trajs_3d{i}.traj{fr - bg_frame}.vel + motion_predict(i, :)';
        fr = fr + 1;
    end
    motion_predict = motion_predict_LSTM(fr);
%     trajs_3d{i}.delta_vel(1 : 3, fr - bg_frame + 1) = motion_predict(i, :)';
    
    
    plot3(trajs_3d{i}.traj{fr - bg_frame}.head_pt(1) + trajs_3d{i}.traj{fr - bg_frame}.vel(1) + motion_predict(i, 1), trajs_3d{i}.traj{fr - bg_frame + 1}.head_pt(2), trajs_3d{i}.traj{fr - bg_frame + 1}.head_pt(3), 'r.');
    
    fr = fr - test_len + 1;
    for ffr = fr : fr + test_len - 1
        trajs_3d{i}.delta_vel(1 : 3, ffr - bg_frame + 1) = tp_delta_vel(1 : 3, ffr - fr + 1);
        trajs_3d{i}.traj{ffr - bg_frame + 1}.vel = tp_vel(1 : 3, ffr - fr + 1);
        trajs_3d{i}.traj{ffr - bg_frame + 1}.head_pt = tp_head_pt(1 : 3, ffr - fr + 1);
    end
%     plot3(trajs_3d{i}.traj{fr - bg_frame + 1}.head_pt(1), trajs_3d{i}.traj{fr - bg_frame + 1}.head_pt(2), trajs_3d{i}.traj{fr - bg_frame + 1}.head_pt(3), 'b.');
    
    toc;
end



end