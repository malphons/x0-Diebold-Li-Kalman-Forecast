function [RateSpec_Stressed,MaturityPeriod,YieldsStressed] = Create_RateSpecificationStressed(YieldCurveFit,ValuationDateNum,MaturityDateNum,StressScenario,varargin)

%% Input Checking
if nargin < 4
    StressScenario = 'ParallelShift';
    varargin{1}    = 0.01;
end

%% Evaluate Yields based on Contract Period
MaturityPeriod            = MaturityDateNum - ValuationDateNum;
MaturityPeriod_Normalized = zscore(MaturityPeriod);
YieldsFitted              = YieldCurveFit(MaturityPeriod_Normalized);

%% Create Rate Specification
switch StressScenario
    case {'Parallel Shift'}
        Delta_ParallelShift = varargin{1};
        YieldsStressed      = YieldsFitted+Delta_ParallelShift;
        RateSpec_Stressed   = intenvset('Rates', YieldsStressed, 'StartDates',ValuationDateNum,'EndDates', MaturityDateNum);
        if nargout == 0
            figure
            plot(MaturityPeriod,YieldsFitted,'ko')
            hold on
            plot(MaturityPeriod,YieldsStressed,'ro')
            legend('Original Yields',['Stressed Yields \bf Parallel Shift @ ' num2str(Delta_ParallelShift*100,'%10.2f') '%'])
        end
    case {'Bear Flattener'}
        PivotPoint_MaturityPeriod = varargin{1};
        Delta_FlatteningAmt       = varargin{2};
        Delta_FlatteningVector    = zeros(size(YieldsFitted));
        [~,Idx_ClosestMaturityPeriod] = min(abs(MaturityPeriod - PivotPoint_MaturityPeriod));
        PivotPoint_ClosestMaturity = MaturityDateNum(Idx_ClosestMaturityPeriod);
        p = polyfit([MaturityDateNum(1) PivotPoint_ClosestMaturity],[YieldsFitted(1)+Delta_FlatteningAmt 0],1);
        Delta_FlatteningVector(1:Idx_ClosestMaturityPeriod) = polyval(p,MaturityDateNum(1:Idx_ClosestMaturityPeriod));
        YieldsStressed = YieldsFitted+Delta_FlatteningVector;

        RateSpec_Stressed = intenvset('Rates',YieldsStressed, 'StartDates',ValuationDateNum,'EndDates', MaturityDateNum);
        if nargout == 0
            figure
            plot(MaturityPeriod,YieldsFitted,'ko')
            hold on
            plot(MaturityPeriod,YieldsStressed,'ro')
            legend('Original Yields',['Stressed Yields \bf Bear Flattener @ ' num2str(PivotPoint_MaturityPeriod/252,'%10.2f') ' Years'])
        end
    otherwise
end