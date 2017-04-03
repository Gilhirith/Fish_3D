function [] = Main_LSTM_midline(speed, sgd)

    global problem_midline;

    % % get data & initialization using feval frunctin handle
    [data, mask] = feval(['train_prepare_' problem_midline.name]);
    problem_midline.numsamples = size(data, 1);

    % % net initialization
    netInit(problem_midline.name);
    
    Bpfunc = @batch_cell_lstm;

    % % check gradient calculation
    if speed.gradientchecking
        for i = 1 : fix(problem_midline.numsamples / problem_midline.batchsize)
            bashdata{i} = data((i - 1) * problem_midline.batchsize + 1 : i * problem_midline.batchsize, :, :);
            maskdata{i} = mask((i - 1) * problem_midline.batchsize + 1 : i * problem_midline.batchsize, :, :);
        end
        globalData = bashdata{1};
        globalMask = maskdata{1};
        [err, dw, inLL, right] = Bpfunc(problem_midline.W, globalData, globalMask);  
        [numgrad] = computeNumericalGradient(Bpfunc, problem_midline.W);
        disp([numgrad dw])
        diff = norm(numgrad - dw) / norm(numgrad + dw);
        disp(diff);
        fprintf('Norm of the difference between numerical and analytical gradient (should be < 1e-9)\n\n');
        return
    end

    for i = 1 : fix(problem_midline.numsamples / problem_midline.batchsize)
        bashdata{i} = data((i - 1) * problem_midline.batchsize + 1 : i * problem_midline.batchsize, :, :);
        maskdata{i} = mask((i - 1) * problem_midline.batchsize + 1 : i * problem_midline.batchsize, :, :);
    end
    
    momentum = sgd.momentum;
    alpha = sgd.alpha;
    oldGradient = 0;

    record = 1;
    for repeat = 1 : 5
        repeat
        tic;
        for inner = 1 : 50
            for i = 1 : fix(problem_midline.numsamples / problem_midline.batchsize)
                globalData = bashdata{i};
                globalMask = maskdata{i};
                [~, dw, ~, ~] = Bpfunc(problem_midline.W, globalData, globalMask, problem_midline.name);
                oldGradient = alpha * dw + momentum * oldGradient;
                problem_midline.W = problem_midline.W - alpha * oldGradient;
            end
            record = record + 1;
        end
        toc;
%         disp(['sgd error ' num2str(errorarray{2}(record - 1))])
    end

end
