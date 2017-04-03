function [data, mask] = train_prepare_fish_midline()

global mzeros convert ang_data nfish problem_midline nfish;
global ed_frame;

data = mzeros(problem_midline.numsamples, 12, ceil(problem_midline.T * 1.1));
mask = mzeros(problem_midline.numsamples, 1, ceil(problem_midline.T * 1.1));

T = fix(problem_midline.T / 1.1);

sample_cnt = 1;

for i = 1 : problem_midline.numsamples / nfish
%     len = T + fix((rand - 1) * (T - 1));
    len = 5;
    for obj = 1 : nfish
%         len = T + fix(rand * T + 1); 
%         len = T + fix(rand * T / 10);

        st = fix(rand * (200 - len - 1)) + 1;
        fg = 0;
        for j = 1 : len
            if length(ang_data{obj}.delta_midline_ang) < st + len - 1 || mean(ang_data{obj}.delta_midline_ang(st + j - 1, 1 : 9)) == 0
                fg = 1;
                break;
            end
        end
        if fg == 1
            continue;
        end
        
        mask(sample_cnt, 1, len) = 1;
        data(sample_cnt, 11, 1 : len) = ones(1, len); % bias
        data(sample_cnt, 12, 1 : len) = ones(1, len); % bias
%         st = fix(rand * (527 - length) / 2) + 1;
        
%         data(sample_cnt, 1, 1 : length) = (ang_data{obj}.vel(st : st + length - 1, 1)) / 50;
%         data(sample_cnt, 2, 1 : length) = (ang_data{obj}.vel(st : st + length - 1, 2)) / 50;
%         data(sample_cnt, 11, 1 : length) = (ang_data{obj}.vel(st + 1 : st + length, 1) - ang_data{obj}.vel(st : st + length - 1, 1)) / 50;
%         data(sample_cnt, 12, 1 : length) = (ang_data{obj}.vel(st + 1 : st + length, 2) - ang_data{obj}.vel(st : st + length - 1, 2)) / 50;
%         data(sample_cnt, 1, 1 : length) = (ang_data{obj}.delta_vel_ang(st : st + length - 1, 1) + pi) / (2 * pi);
%         data(sample_cnt, 2, 1 : length) = sqrt(ang_data{obj}.vel(st : st + length - 1, 1).^2 + ang_data{obj}.vel(st : st + length - 1, 2).^2) / 50;
%         data(sample_cnt, 20, 1 : length) = cos(ang_data{obj}.vel_ang(st + 1 : st + length, 1) - ang_data{obj}.vel_ang(st : st + length - 1, 1));
%         data(sample_cnt, 21, 1 : length) = sin(ang_data{obj}.vel_ang(st + 1 : st + length, 1) - ang_data{obj}.vel_ang(st : st + length - 1, 1));

%         st + len - 1
%         length(ang_data{obj}.delta_midline_ang)
        data(sample_cnt, 1 : 9, 1 : len) = (ang_data{obj}.delta_midline_ang(st : st + len - 1, 2 : 10)' + pi) / (2 * pi);
%         data(sample_cnt, 1 : 2 : 17, 1 : length) = cos(ang_data{obj}.ang(st : st + length - 1, 1 : 9)');
%         data(sample_cnt, 2 : 2 : 18, 1 : length) = sin(ang_data{obj}.ang(st : st + length - 1, 1 : 9)');
%         data(sample_cnt, 20, 1 : length) = cos(ang_data{obj}.delta_vel_ang(st : st + length - 1, 1));
%         data(sample_cnt, 21, 1 : length) = sin(ang_data{obj}.delta_vel_ang(st : st + length - 1, 1));
        data(sample_cnt, 10, 1 : len) = (ang_data{obj}.delta_ori(st : st + len - 1, 1) + pi) / (2 * pi);
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

