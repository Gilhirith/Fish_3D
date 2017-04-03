function State_Predict_LSTM()

global trajs_3d;
global fr;
global bg_frame;
global delta_frame;
global problem_motion mones mzeros convert usegpu signum;
global motion_predict;

motion_predict = zeros(length(trajs_3d), 3);

for i = 1 : length(trajs_3d)
    if fr == bg_frame
        return;
    end
    if fr == bg_frame + delta_frame
        trajs_3d{i}.traj{fr - bg_frame + 1}.vel = [0 0 0];
        return;
    end
    if fr == bg_frame + 2 * delta_frame
        trajs_3d{i}.traj{fr - bg_frame + 1 - delta_frame}.vel = trajs_3d{i}.traj{fr - bg_frame + 1 - delta_frame}.head_pt - trajs_3d{i}.traj{fr - bg_frame + 1 - 2 * delta_frame}.head_pt;
        return;
    end
    trajs_3d{i}.traj{fr - bg_frame + 1 - delta_frame}.vel = trajs_3d{i}.traj{fr - bg_frame + 1 - delta_frame}.head_pt - trajs_3d{i}.traj{fr - bg_frame + 1 - 2 * delta_frame}.head_pt;
    trajs_3d{i}.delta_vel(1 : 3, fr - bg_frame + 1 - delta_frame) = trajs_3d{i}.traj{fr - bg_frame + 1 - delta_frame}.vel - trajs_3d{i}.traj{fr - bg_frame + 1 - 2 * delta_frame}.vel;
end

motion_predict = motion_predict_LSTM(fr);
% 
% for i = 1 : length(trajs_3d)
%     trajs_3d{i}.delta_vel(1 : 3, fr - bg_frame + 1 + delta_frame) = motion_predict(i, :)';
% end

end