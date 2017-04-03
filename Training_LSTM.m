function Training_LSTM()

    global trajs_3d nfish problem_motion;
    global mones mzeros convert usegpu signum;
    
    format long
    addpath(genpath('../'));
    result_motion.resume = 0;
    result_motion.savemat = 0;
    result_motion.savepic = 0;
    result_motion.savePath = './results/';
    result_motion.dataPath = './data/';
    result_motion.picPath =  './pic/';
    result_motion.linespec = {'r.-', 'b*-', 'go-', 'rs-', 'b^-', 'gd-', 'r--'};

    speed_motion.usegpu = 'cpu_double';
    speed_motion.usecluster = 0;
    speed_motion.numcluster = 4;
    speed_motion.machine = 'lqc';
    speed_motion.gradientchecking = 0;

    options_motion.maxIter = 1e5;
    options_motion.display = 'off';
    options_motion.LS_init = 2;
    options_motion.maxFunEvals = 50;
    options_motion.Corr = 10;
    options_motion.optTol = 1e-66;
    options_motion.TolX = 1e-66;
    options_motion.TolFun = 1e-66;

    % problem.name = 'adding';
    problem_motion.name = 'fish_motion';
    problem_motion.datapath = './timit/';
    problem_motion.numsamples = 2000; %  not enough 20000
    problem_motion.batchsize = 10; % not enough 200
    problem_motion.T = 10;
    problem_motion.Ttest = problem_motion.T;
    problem_motion.numtest = nfish; % 3000
    problem_motion.gate_size = 2;

    problem_motion.numMmcell = 10;
    problem_motion.continualPredict = 0;
    problem_motion.bias1 = 1; % other bias
    problem_motion.bias2 = 1; % output bias

    sgd_motion.alpha = 0.1;
    sgd_motion.momentum = 0.9;
    
    [mones, mzeros, convert, usegpu] = gputype(speed_motion.usegpu);
    signum = 1;
    
    Main_LSTM_motion(speed_motion, sgd_motion);

end