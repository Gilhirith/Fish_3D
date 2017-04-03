function [] = Main_LSTM_motion(speed, sgd)

    global globalData globalMask problem_motion;

    % % get data & initialization using feval frunctin handle
    [data, mask] = feval(['train_prepare_' problem_motion.name]);
    problem_motion.numsamples = size(data, 1);

    % % net initialization
    netInit(problem_motion.name);
    
    Bpfunc = @batch_cell_lstm;

    % % check gradient calculation
    if speed.gradientchecking
        for i = 1 : fix(problem_motion.numsamples / problem_motion.batchsize)
            bashdata{i} = data((i - 1) * problem_motion.batchsize + 1 : i * problem_motion.batchsize, :, :);
            maskdata{i} = mask((i - 1) * problem_motion.batchsize + 1 : i * problem_motion.batchsize, :, :);
        end
        globalData = bashdata{1};
        globalMask = maskdata{1};
        [err, dw, inLL, right] = Bpfunc(problem_motion.W);  
        [numgrad] = computeNumericalGradient(Bpfunc, problem_motion.W);
        disp([numgrad dw])
        diff = norm(numgrad - dw) / norm(numgrad + dw);
        disp(diff);
        fprintf('Norm of the difference between numerical and analytical gradient (should be < 1e-9)\n\n');
        return
    end

    for i = 1 : fix(problem_motion.numsamples / problem_motion.batchsize)
        bashdata{i} = data((i - 1) * problem_motion.batchsize + 1 : i * problem_motion.batchsize, :, :);
        maskdata{i} = mask((i - 1) * problem_motion.batchsize + 1 : i * problem_motion.batchsize, :, :);
    end
    
    momentum = sgd.momentum;
    alpha = sgd.alpha;
    oldGradient = 0;

    record = 1;
    for repeat = 1 : 5
        repeat
        tic;
        for inner = 1 : 50
            for i = 1 : fix(problem_motion.numsamples / problem_motion.batchsize)
                globalData = bashdata{i};
                globalMask = maskdata{i};
                [~, dw, ~, ~] = Bpfunc(problem_motion.W, globalData, globalMask, problem_motion.name);
                oldGradient = alpha * dw + momentum * oldGradient;
                problem_motion.W = problem_motion.W - alpha * oldGradient;
            end
            record = record + 1;
        end
        toc;
%         disp(['sgd error ' num2str(errorarray{2}(record - 1))])
    end

end
