function [test, masktest] = predict_prepare_fish_midline()

global mzeros convert nfish problem_midline bg_frame trajs fr;
global delta_frame;
global bg_frame;

test = mzeros(problem_midline.numtest, 12, ceil(problem_midline.T * 1.1));
masktest = mzeros(problem_midline.numtest, 1, ceil(problem_midline.T * 1.1));

T = fix(problem_midline.T / 1.1);

test_cnt = 1;

for obj = 1 : length(trajs)
    len = fr - max(fr - problem_midline.T * delta_frame, bg_frame);
    masktest(test_cnt, 1, len) = 1;
    test(test_cnt, 11, 1 : len) = ones(1, len); % bias
    test(test_cnt, 12, 1 : len) = ones(1, len); % bias
    tp_len = 1;
    for i = max(fr - problem_midline.T * delta_frame, bg_frame) : delta_frame : fr - delta_frame
        obj
        i
        test(test_cnt, 1 : 9, tp_len) = (trajs{obj}.state{i}.delta_midline_ang(2 : 10) + pi) / (2 * pi);
        test(test_cnt, 10, tp_len) = (trajs{obj}.state{i}.delta_ori + pi) / (2 * pi);
        tp_len = tp_len + 1;
    end
    test_cnt = test_cnt + 1;
end

for i = size(test, 3) : -1 : 1
    if max(max(test(:, :, i))) ~= 0
        test = test(:, :, 1 : i);
        break
    end
end

test = convert(test);
masktest = convert(masktest);
