function [test, masktest] = predict_prepare_fish_motion()

global mzeros convert ang_data nfish problem_motion bg_frame trajs_3d fr;
global ed_frame;
global delta_frame;

test = mzeros(problem_motion.numtest, 5, ceil(problem_motion.T * 1.1));
masktest = mzeros(problem_motion.numtest, 1, ceil(problem_motion.T * 1.1));

T = fix(problem_motion.T / 1.1);

test_cnt = 1;

for obj = 1 : length(trajs_3d)
    len = fr - max(fr - problem_motion.T * delta_frame, bg_frame);
    masktest(test_cnt, 1, len) = 1;
    test(test_cnt, 4, 1 : len) = ones(1, len); % bias
    test(test_cnt, 5, 1 : len) = ones(1, len); % bias
    tp_len = 1;
    if max(fr - problem_motion.T * delta_frame, trajs_3d{obj}.bg_frame) <= min(fr - delta_frame, trajs_3d{obj}.ed_frame)
        for i = max(fr - problem_motion.T * delta_frame, trajs_3d{obj}.bg_frame) : delta_frame : min(fr - delta_frame, trajs_3d{obj}.ed_frame)
            test(test_cnt, 1 : 3, tp_len) = trajs_3d{obj}.delta_vel(1 : 3, i - bg_frame + 1);
            tp_len = tp_len + 1;
        end
    else
        test(test_cnt, 1 : 3, 1) = zeros(3, 1);
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
