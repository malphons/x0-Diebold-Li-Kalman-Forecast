function plotSlopeEstimate(hAxes)

%% Input Checking
if nargin == 0
    L1 = load('TwoStepModel.mat');
    beta = L1.beta;
    L2 = load('SSMModel.mat');
    estimatedStates = L2.estimatedStates;
    dates = L2.dates;
    figure;
    hAxes = gca;
elseif nargin == 1
    L1 = load('TwoStepModel.mat');
    beta = L1.beta;
    L2 = load('SSMModel.mat');
    estimatedStates = L2.estimatedStates;
    dates = L2.dates;    
end

%% Visualize
plot(hAxes,dates, [beta(:,2) estimatedStates(:,2)])
title(hAxes,'Slope (Short-Term Factor)')
ylabel(hAxes,'Percent')
legend(hAxes,{'Two-Step','State-Space Model'},'location','best')