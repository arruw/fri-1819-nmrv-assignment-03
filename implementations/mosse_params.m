function params = mosse_params()
    params = struct;
    
    % gaussian sigma
    params.sigma = 2;
    % gaussian peak
    params.peak = 100;
    
    % search to target region ration
    params.s2tr = 2;
    
    % learning rate
    params.alpha = 0.1;
    
    % minimal PSR
    params.psr = 0.08; 
    
    % regularization parameter
    params.lambda = 0.002
end