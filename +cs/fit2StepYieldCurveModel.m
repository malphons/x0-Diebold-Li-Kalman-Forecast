function [EstMdlVAR,residuals,beta] = fit2StepYieldCurveModel(yields,maturities)

%% Input Checking
if nargin == 0
    L = cs.loadDiebolLiData();
    yields = L.yields;
    maturities = L.maturities;
end

%% Run Model
lambda0 = 0.0609;
X = [ones(size(maturities)) (1-exp(-lambda0*maturities))./(lambda0*maturities) ...
    ((1-exp(-lambda0*maturities))./(lambda0*maturities)-exp(-lambda0*maturities))];

beta = zeros(size(yields,1),3);
residuals = zeros(size(yields,1),numel(maturities));

for i = 1:size(yields,1)
    EstMdlOLS = fitlm(X, yields(i,:)', 'Intercept', false);
    beta(i,:) = EstMdlOLS.Coefficients.Estimate';
    residuals(i,:) = EstMdlOLS.Residuals.Raw';
end

EstMdlVAR = estimate(varm(3,1), beta);