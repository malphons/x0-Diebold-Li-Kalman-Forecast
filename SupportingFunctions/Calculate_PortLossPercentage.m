function [OriginalPortValuation,StressedPortValuation,Portfolio_LossPercent] = Calculate_PortLossPercentage(CurrentPrices,StressedPrices)

OriginalPortValuation = sum(CurrentPrices);
StressedPortValuation = sum(StressedPrices);
Portfolio_LossPercent = 100*(StressedPortValuation - OriginalPortValuation)/OriginalPortValuation;

if nargout == 0
    if Portfolio_LossPercent < 0
        disp(['Portfolio Loss = ' num2str(Portfolio_LossPercent,'%10.2f') '%'])
    else
        disp(['Portfolio Gain = ' num2str(Portfolio_LossPercent,'%10.2f') '%'])
    end
end