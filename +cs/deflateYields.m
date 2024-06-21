function [intercept,deflatedYields,deflatedStates,estimatedStates] = deflateYields()

%% Input Checking
if nargin == 0
    L1 = cs.loadDiebolLiData();
    yields = L1.yields;
    
    L2 = load('SSMModel.mat');
    mu = L2.mu;
    EstMdlSSM = L2.EstMdlSSM;
end

%% Deflate Yields & Estimate States
intercept = EstMdlSSM.C * mu';
deflatedYields = yields - intercept';
deflatedStates = smooth(EstMdlSSM,deflatedYields);
estimatedStates = deflatedStates + mu;