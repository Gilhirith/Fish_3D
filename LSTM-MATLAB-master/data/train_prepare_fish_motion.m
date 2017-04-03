function [data, mask] = train_prepare_fish_motion()

global mzeros convert trackers problem_motion;

% % train for data cv_217
bg_frame = 325;
ed_frame = 865;
delta_frame = 1;
nfish = 10;

data = mzeros(problem_motion.numsamples, 5, ceil(problem_motion.T * 1.1));
mask = mzeros(problem_motion.numsamples, 1, ceil(problem_motion.T * 1.1));

T = fix(problem_motion.T / 1.1);

sample_cnt = 1;

for i = 1 : problem_motion.numsamples / nfish
    length = problem_motion.T;
%     length = T + fix((rand - 1) * (T - 1));
    for obj = 1 : nfish
%         length = T + fix(rand * T + 1);
%         length = T + fix(rand * T / 10);
%         length = T + fix(rand * T / 10);
        len_traj = trackers(obj).end - trackers(obj).start + 1;
        st = fix(rand * (len_traj - length - 3)) + 1;
        
        mask(sample_cnt, 1, length) = 1;
        data(sample_cnt, 4, 1 : length) = ones(1, length); % bias
        data(sample_cnt, 5, 1 : length) = ones(1, length); % bias
%         st = fix(rand * (527 - length) / 2) + 1;

%         data(sample_cnt, 1, 1 : length) = (ang_data{obj}.vel(st : st + length - 1, 1)) / 50;
%         data(sample_cnt, 2, 1 : length) = (ang_data{obj}.vel(st : st + length - 1, 2)) / 50;
%         data(sample_cnt, 11, 1 : length) = (ang_data{obj}.vel(st + 1 : st + length, 1) - ang_data{obj}.vel(st : st + length - 1, 1)) / 50;
%         data(sample_cnt, 12, 1 : length) = (ang_data{obj}.vel(st + 1 : st + length, 2) - ang_data{obj}.vel(st : st + length - 1, 2)) / 50;
%         st
%         st + length - 1
        data(sample_cnt, 1 : 3, 1 : length) = trajs_3d{obj}.delta_vel(1 : 3, st : st + length - 1);
%         data(sample_cnt, 20, 1 : length) = cos(ang_data{obj}.vel_ang(st + 1 : st + length, 1) - ang_data{obj}.vel_ang(st : st + length - 1, 1));
%         data(sample_cnt, 21, 1 : length) = sin(ang_data{obj}.vel_ang(st + 1 : st + length, 1) - ang_data{obj}.vel_ang(st : st + length - 1, 1));
%         data(sample_cnt, 1 : 9, 1 : length) = (ang_data{obj}.delta_midline_ang(st : st + length - 1, 1 : 9)' + pi) / (2 * pi);
%         data(sample_cnt, 1 : 2 : 17, 1 : length) = cos(ang_data{obj}.ang(st : st + length - 1, 1 : 9)');
%         data(sample_cnt, 2 : 2 : 18, 1 : length) = sin(ang_data{obj}.ang(st : st + length - 1, 1 : 9)');
%         data(sample_cnt, 20, 1 : length) = cos(ang_data{obj}.delta_vel_ang(st : st + length - 1, 1));
%         data(sample_cnt, 21, 1 : length) = sin(ang_data{obj}.delta_vel_ang(st : st + length - 1, 1));
%         data(sample_cnt, 10, 1 : length) = (ang_data{obj}.delta_ori(st : st + length - 1, 1) + pi) / (2 * pi);
%         if max(max(data(sample_cnt, 2 : 10, 1 : length)))
        sample_cnt = sample_cnt + 1;
    end
end

for i = size(data, 3) : -1 : 1
    if max(max(data(:, :, i))) ~= 0
        data = data(:, :, 1 : i);
        break
    end
end

data = convert(data);
mask = convert(mask);

