function Plot_YieldCurveFit(ValuationDate,Maturity,YTM,YieldFit,h_Axis)

%% Input Checking
if nargin < 5
    figure;
    h_Axis = gca;
end

%% Setup Key Variables
x_Maturity              = (Maturity - ValuationDate);
x_MaturityNormalized    = Calculate_NormalizeYields4Fitting(x_Maturity,true);
I_BadBonds              = (YTM < 0) | (YTM > YieldFit(x_MaturityNormalized)+0.05) | (YTM < YieldFit(x_MaturityNormalized)-0.05) ;

%% Plot Yield Curve
plot(h_Axis,Maturity(~I_BadBonds),YTM(~I_BadBonds),'ko')
hold(h_Axis,'on')
h_BadPoints = plot(h_Axis,Maturity(I_BadBonds),YTM(I_BadBonds),'ro');
set(h_BadPoints,'MarkerFaceColor','red')
datetick(h_Axis)
plot(h_Axis,Maturity,YieldFit(x_MaturityNormalized),'bx')
legend(h_Axis,{'Yields to Maturity','YTM Outliers','Fitted Nelson Siegel Curve'},'location','best')
grid(h_Axis,'on')
axis(h_Axis,[Maturity(1) Maturity(end) min(YTM) max(YTM)])