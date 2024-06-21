function RateSpec = Create_RateSpecification(YieldCurveFit,ValuationDateNum,MaturityDateNum,delta_ParallelShift)

%% Input Checking
if nargin < 4
    delta_ParallelShift = 0;
end

%% Evaluate Yields based on Contract Period
MaturityPeriod            = MaturityDateNum - ValuationDateNum;
MaturityPeriod_Normalized = zscore(MaturityPeriod);
Yields                    = YieldCurveFit(MaturityPeriod_Normalized) + delta_ParallelShift ;

%% Create Rate Specification
RateSpec                  = intenvset('Rates', Yields, ...
                                      'StartDates',ValuationDateNum, ...
                                      'EndDates', MaturityDateNum);