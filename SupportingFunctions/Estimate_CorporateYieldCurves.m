function [YieldCurve_InvestmentGrade,YieldCurve_HighYield,Bonds_InvestmentGrade,Bonds_HighYield] = Estimate_CorporateYieldCurves(Bonds)
%% Estimate_YieldCorporateYieldCurve
%
% Function to create
% * YieldCurve_InvestmentGrade
% * YieldCurve_HighYield
% * Bonds_InvestmentGrade
% * Bonds_HighYield

%% Parameter Setup
% One_Year            = 252;
% One_Month           = One_Year/12;
ValuationDate       = Bonds.TradeDateNum(1);

I_Outlier           = Bonds.YTM > mean(Bonds.YTM) + 2*std(Bonds.YTM);
I_YieldsZeros       = Bonds.CurrentYield <= 1e-6;

IR.CurveRatings     = {'Investment Grade';'High Yield'};
IR.CurveFit         = cell(length(IR.CurveRatings),1);
YieldFit            = cell(length(IR.CurveRatings),1);
BondsTemp           = cell(length(IR.CurveRatings),1);

%% Segment Ratings
I_Ratings{1}        = Bonds.Rating >= 'BBB' & ~I_Outlier & ~I_YieldsZeros;
I_Ratings{2}        = Bonds.Rating < 'BBB' & ~I_Outlier & ~I_YieldsZeros;
                                             % 1Month    3Month      6Month      1Year    2Year      3Year      5Year      7Year      10Year      20Year      30Year
% Dates_TermStructure = daysadd(ValuationDate,[One_Month 3*One_Month 6*One_Month One_Year 2*One_Year 3*One_Year 5*One_Year 7*One_Year 10*One_Year 20*One_Year 30*One_Year],1);
N                   = length(IR.CurveRatings);

for i = 1:N
    I_Rating        = I_Ratings{i};
    Maturity        = Bonds.MaturityNum(I_Rating);
    YTM             = Bonds.YTM(I_Rating)/100;
    BondsTemp{i}    = Bonds(I_Rating,:);
    
    x_Maturity              = (Maturity - ValuationDate);
    x_MaturityNormalized    = Calculate_NormalizeYields4Fitting(x_Maturity,true);
%     YieldFit{i}             = createYCFit(x_MaturityNormalized,YTM);
    YieldFit{i}             = Fit_NelsonSiegelSvensonModel(x_MaturityNormalized,YTM);

    if nargout == 0
        I_BadBonds              = YTM < 0 | (YTM > YieldFit{i}(x_MaturityNormalized)+0.1) | (YTM < YieldFit{i}(x_MaturityNormalized)-0.1) ;
        Plot_YieldCurveFit(ValuationDate,Maturity,YTM,YieldFit{i})
        title(['\bf Yield Curve (' IR.CurveRatings{i} ')'])
        
        BondsTemp{i}(I_BadBonds,:) = [];  
    end
end

YieldCurve_InvestmentGrade = YieldFit{1};
YieldCurve_HighYield       = YieldFit{2};
Bonds_InvestmentGrade      = BondsTemp{1};
Bonds_HighYield            = BondsTemp{2};