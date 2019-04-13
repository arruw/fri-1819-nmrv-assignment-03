% DO NOT CHANGE THIS FILE, IT IS AUTO GENERATED FROM THE TEMPLATE './implementations/mosse_params.template'

function params = mosse_params()

    params = struct;
    % gaussian sigma
    params.sigma = 2;
    % gaussian peak
    params.peak = 100;
    % search to target region ration
    params.s2tr = 2;
    % learning rate
    params.alpha = 0.125;
    % minimal PSR
    params.psr = 0.05; 
    % regularization parameter
    params.lambda = 1e-05;
end