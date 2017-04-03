function [] = netInit(problem_name)

    global mones mzeros problem_midline problem_motion;

    if strcmp(problem_name, 'fish_midline') == 1
        problem_midline.in_size = 10;
        problem_midline.out_size = problem_midline.in_size;
        
        problem_midline.node_outgateInit = cell(1, problem_midline.T);
        problem_midline.cellinInit = problem_midline.node_outgateInit;
        problem_midline.node_cellbiasInit = problem_midline.node_outgateInit;
        problem_midline.delta_outInit = problem_midline.node_outgateInit;
        problem_midline.cellstatusInit = problem_midline.node_outgateInit;
        
        for i = 1 : problem_midline.T
            problem_midline.node_outgateInit{i} = 0.5 * mones(problem_midline.batchsize, problem_midline.gate_size);
            problem_midline.cellinInit{i} = mzeros(problem_midline.batchsize, problem_midline.numMmcell * problem_midline.gate_size);
            problem_midline.node_cellbiasInit{i} = mones(problem_midline.batchsize, 1);
            problem_midline.delta_outInit{i} = mzeros(problem_midline.batchsize, problem_midline.out_size);
            problem_midline.cellstatusInit{i} = mzeros(problem_midline.batchsize, problem_midline.numMmcell * problem_midline.gate_size);
        end

        ingatebias = -1;

        problem_midline.in_size = problem_midline.in_size + problem_midline.bias1;
        % share_size include ingate, status, outgate, cellout 
        problem_midline.share_size = problem_midline.in_size + problem_midline.gate_size * (2 + 2 * problem_midline.numMmcell) ; 
        problem_midline.share_size2 = problem_midline.gate_size * problem_midline.share_size;
        % share_size2 is weights for a layer of lstm, lstm has 4 layer: ingate, cell
        % outgate, out ,added up to psize
        psize = 2 * problem_midline.share_size2 + problem_midline.share_size2 * problem_midline.numMmcell + (problem_midline.gate_size * problem_midline.numMmcell + 1) * problem_midline.out_size;

        node_size = problem_midline.in_size + problem_midline.gate_size * (2 + 2 * problem_midline.numMmcell) + problem_midline.out_size + problem_midline.bias2;
        nodeindex = 1 : node_size;
        problem_midline.in = nodeindex(1 : problem_midline.in_size);
        problem_midline.ingate = nodeindex(problem_midline.in_size + 1 : problem_midline.in_size + problem_midline.gate_size );
        problem_midline.cellstate = nodeindex(problem_midline.in_size + problem_midline.gate_size + 1 : problem_midline.in_size + (1 + problem_midline.numMmcell) * problem_midline.gate_size);
        problem_midline.cells = nodeindex(problem_midline.in_size + (1 + problem_midline.numMmcell) * problem_midline.gate_size + 1 : problem_midline.in_size + (1 + 2 * problem_midline.numMmcell) * problem_midline.gate_size);
        problem_midline.outgate = nodeindex(problem_midline.in_size + (1 + 2 * problem_midline.numMmcell) * problem_midline.gate_size + 1: problem_midline.in_size + (2 + 2 * problem_midline.numMmcell) * problem_midline.gate_size);

        W = 1e-4 * (mod(fix(2^50 * rand(psize, 1)), 2000) -1000);

        for i = 1 : psize / problem_midline.gate_size
            W(ceil(rand * psize)) = 0;
        end

        [Wingate, Wcell, Woutgate, Wout] = unpack(W, problem_midline.share_size, problem_midline.share_size2, problem_midline.gate_size, problem_midline.numMmcell, problem_midline.out_size);
        Wingate(problem_midline.in(end), :) = Wingate(problem_midline.in(end), :) + ingatebias;
        problem_midline.W = pack(Wingate, Wcell, Woutgate, Wout);
    
    else
        problem_motion.in_size = 3;
        problem_motion.out_size = problem_motion.in_size;
        
        problem_motion.node_outgateInit = cell(1, problem_motion.T);
        problem_motion.cellinInit = problem_motion.node_outgateInit;
        problem_motion.node_cellbiasInit = problem_motion.node_outgateInit;
        problem_motion.delta_outInit = problem_motion.node_outgateInit;
        problem_motion.cellstatusInit = problem_motion.node_outgateInit;
        
        for i = 1 : problem_motion.T
            problem_motion.node_outgateInit{i} = 0.5 * mones(problem_motion.batchsize, problem_motion.gate_size);
            problem_motion.cellinInit{i} = mzeros(problem_motion.batchsize, problem_motion.numMmcell * problem_motion.gate_size);
            problem_motion.node_cellbiasInit{i} = mones(problem_motion.batchsize, 1);
            problem_motion.delta_outInit{i} = mzeros(problem_motion.batchsize, problem_motion.out_size);
            problem_motion.cellstatusInit{i} = mzeros(problem_motion.batchsize, problem_motion.numMmcell * problem_motion.gate_size);
        end

        ingatebias = -1;
        
        problem_motion.in_size = problem_motion.in_size + problem_motion.bias1;
        % share_size include ingate, status, outgate, cellout 
        problem_motion.share_size = problem_motion.in_size + problem_motion.gate_size * (2 + 2 * problem_motion.numMmcell) ; 
        problem_motion.share_size2 = problem_motion.gate_size * problem_motion.share_size;
        % share_size2 is weights for a layer of lstm, lstm has 4 layer: ingate, cell
        % outgate, out ,added up to psize
        psize = 2 * problem_motion.share_size2 + problem_motion.share_size2 * problem_motion.numMmcell + (problem_motion.gate_size * problem_motion.numMmcell + 1) * problem_motion.out_size;

        node_size = problem_motion.in_size + problem_motion.gate_size * (2 + 2 * problem_motion.numMmcell) + problem_motion.out_size + problem_motion.bias2;
        nodeindex = 1 : node_size;
        problem_motion.in = nodeindex(1 : problem_motion.in_size);
        problem_motion.ingate = nodeindex(problem_motion.in_size + 1 : problem_motion.in_size + problem_motion.gate_size );
        problem_motion.cellstate = nodeindex(problem_motion.in_size + problem_motion.gate_size + 1 : problem_motion.in_size + (1 + problem_motion.numMmcell) * problem_motion.gate_size);
        problem_motion.cells = nodeindex(problem_motion.in_size + (1 + problem_motion.numMmcell) * problem_motion.gate_size + 1 : problem_motion.in_size + (1 + 2 * problem_motion.numMmcell) * problem_motion.gate_size);
        problem_motion.outgate = nodeindex(problem_motion.in_size + (1 + 2 * problem_motion.numMmcell) * problem_motion.gate_size + 1: problem_motion.in_size + (2 + 2 * problem_motion.numMmcell) * problem_motion.gate_size);

        W = 1e-4 * (mod(fix(2^50 * rand(psize, 1)), 2000) -1000);

        for i = 1 : psize / problem_motion.gate_size
            W(ceil(rand * psize)) = 0;
        end

        [Wingate, Wcell, Woutgate, Wout] = unpack(W, problem_motion.share_size, problem_motion.share_size2, problem_motion.gate_size, problem_motion.numMmcell, problem_motion.out_size);
        Wingate(problem_motion.in(end), :) = Wingate(problem_motion.in(end), :) + ingatebias;
        problem_motion.W = pack(Wingate, Wcell, Woutgate, Wout);
    end
    
    function [W] = pack(Wingate, Wcell, Woutgate, Wout)
        W = [Wingate(:); Wcell(:); Woutgate(:); Wout(:)];
    end

    function [Wingate, Wcell, Woutgate, Wout] = unpack(W, share_size, share_size2, gate_size, numMmcell, out_size)
        Wingate = reshape(W(1 : share_size2), share_size, gate_size);
        Wcell = reshape(W(share_size2 + 1 : share_size2 * (1 + numMmcell) ), share_size, numMmcell * gate_size);
        Woutgate = reshape(W((1 + numMmcell) * share_size2 + 1 : (2 + numMmcell) * share_size2), share_size, gate_size);
        Wout = reshape(W((2 + numMmcell) * share_size2 + 1 : end ), gate_size * numMmcell + 1, out_size);
    end

end