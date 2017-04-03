function [data, mask, test, masktest] = genfish(problem)

global mzeros convert ang_data nfish

data = mzeros(problem.numsamples, 11, ceil(problem.T * 1.1));
mask = mzeros(problem.numsamples, 1, ceil(problem.T * 1.1));
test = mzeros(problem.numtest, 11, ceil(problem.Ttest * 1.1));
masktest = mzeros(problem.numtest, 1, ceil(problem.Ttest * 1.1));

T = fix(problem.T / 1.1);

load('delta_midline_ang_cv275_528-1054.mat');

sample_cnt = 1;

for obj = 1 : nfish
    for i = 1 : problem.numsamples / nfish
        length = T + fix(rand * T / 10);
        mask(sample_cnt, 1, length) = 1;
        data(sample_cnt, 10, 1 : length) = ones(1, length); % bias
        data(sample_cnt, 11, 1 : length) = ones(1, length); % bias
%         st = fix(rand * (527 - length) / 2) + 1;
        st = fix(rand * (527 - length)) + 1;
%         data(sample_cnt, 1, 1 : length) = (ang_data{obj}.vel(st : st + length - 1, 1)) / 50;
%         data(sample_cnt, 2, 1 : length) = (ang_data{obj}.vel(st : st + length - 1, 2)) / 50;
%         data(sample_cnt, 11, 1 : length) = (ang_data{obj}.vel(st + 1 : st + length, 1) - ang_data{obj}.vel(st : st + length - 1, 1)) / 50;
%         data(sample_cnt, 12, 1 : length) = (ang_data{obj}.vel(st + 1 : st + length, 2) - ang_data{obj}.vel(st : st + length - 1, 2)) / 50;
%         data(sample_cnt, 1, 1 : length) = (ang_data{obj}.delta_vel_ang(st : st + length - 1, 1) + pi) / (2 * pi);
%         data(sample_cnt, 2, 1 : length) = sqrt(ang_data{obj}.vel(st : st + length - 1, 1).^2 + ang_data{obj}.vel(st : st + length - 1, 2).^2) / 50;
%         data(sample_cnt, 20, 1 : length) = cos(ang_data{obj}.vel_ang(st + 1 : st + length, 1) - ang_data{obj}.vel_ang(st : st + length - 1, 1));
%         data(sample_cnt, 21, 1 : length) = sin(ang_data{obj}.vel_ang(st + 1 : st + length, 1) - ang_data{obj}.vel_ang(st : st + length - 1, 1));
        data(sample_cnt, 1 : 9, 1 : length) = (ang_data{obj}.delta_midline_ang(st : st + length - 1, 1 : 9)' + pi) / (2 * pi);
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

clear ang_data;
load('delta_midline_ang_cv275_2400-2512.mat');

test_cnt = 1;

for obj = 1 : nfish
    for i = 1 : problem.numtest / nfish
        length = T + fix(rand * T / 10);
        masktest(test_cnt, 1, length) = 1;
        test(test_cnt, 10, 1 : length) = ones(1, length); % bias
        test(test_cnt, 11, 1 : length) = ones(1, length); % bias
        st = fix(rand * (113 - length)) + 1;
%         test(test_cnt, 1, 1 : length) = (ang_data{obj}.vel(st : st + length - 1, 1)) / 50;
%         test(test_cnt, 2, 1 : length) = (ang_data{obj}.vel(st : st + length - 1, 2)) / 50;
%         test(test_cnt, 11, 1 : length) = (ang_data{obj}.vel(st + 1 : st + length, 1) - ang_data{obj}.vel(st : st + length - 1, 1)) / 50;
%         test(test_cnt, 12, 1 : length) = (ang_data{obj}.vel(st + 1 : st + length, 2) - ang_data{obj}.vel(st : st + length - 1, 2)) / 50;
%         st = fix(rand * (527 - length) / 2 + (527 - length) / 2) + 1;
%         test(test_cnt, 1, 1 : length) = (ang_data{obj}.delta_vel_ang(st : st + length - 1, 1) + pi) / (2 * pi);
%         test(test_cnt, 2, 1 : length) = sqrt(ang_data{obj}.vel(st : st + length - 1, 1).^2 + ang_data{obj}.vel(st : st + length - 1, 2).^2) / 50;
%         test(test_cnt, 1 : 2, 1 : length) = ang_data{obj}.vel(st : st + length - 1, 1 : 2)';
%         test(test_cnt, 20, 1 : length) = cos(ang_data{obj}.vel_ang(st + 1 : st + length, 1) - ang_data{obj}.vel_ang(st : st + length - 1, 1));
%         test(test_cnt, 21, 1 : length) = sin(ang_data{obj}.vel_ang(st + 1 : st + length, 1) - ang_data{obj}.vel_ang(st : st + length - 1, 1));
        test(test_cnt, 1 : 9, 1 : length) = (ang_data{obj}.delta_midline_ang(st : st + length - 1, 1 : 9)' + pi) / (2 * pi);
%         test(test_cnt, 10, 1 : length) = (ang_data{obj}.delta_ori(st : st + length - 1, 1) + pi) / (2 * pi);
%         test(test_cnt, 1 : 2 : 17, 1 : length) = cos(ang_data{obj}.ang(st : st + length - 1, 1 : 9)');
%         test(test_cnt, 2 : 2 : 18, 1 : length) = sin(ang_data{obj}.ang(st : st + length - 1, 1 : 9)');
%         test(test_cnt, 20, 1 : length) = cos(ang_data{obj}.delta_vel_ang(st : st + length - 1, 1));
%         test(test_cnt, 21, 1 : length) = sin(ang_data{obj}.delta_vel_ang(st : st + length - 1, 1));
%         test(test_cnt, 2, 1 : length) = sin(ang_data{obj}.ori(st : st + length - 1, 1));
        test_cnt = test_cnt + 1;
    end
end

for i = size(test, 3) : -1 : 1
    if max(max(test(:, :, i))) ~= 0
        test = test(:, :, 1 : i);
        break
    end
end

tmp = test;
test = mzeros(size(test, 1), size(test, 2), size(test, 3) + 1);
test(:, :, 1) = tmp(:, :, 1);
test(:, :, 2 : end) = tmp;


masktest = masktest(:, :, 1 : size(test, 3));
tmp = masktest;
masktest = mzeros(size(masktest, 1), size(masktest, 2), size(masktest, 3) + 1);
masktest(:, :, 1) = tmp(:, :, 1);
masktest(:, :, 2 : end) = tmp;

data = convert(data);
mask = convert(mask);
test = convert(test);
masktest = convert(masktest);
