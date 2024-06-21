function [EstMdlSSM,lambda,mu,deflatedYields,estimatedStates] = fitSSMofAYieldCurve(yields,maturities)

%% Input Checking
if nargin == 0
    L = cs.loadDiebolLiData();
    yields = L.yields;
    maturities = L.maturities;
    
    L = load('TwoStepModel.mat');
    EstMdlVAR = L.EstMdlVAR;
    lambda0   = L.lambda0;
    residuals = L.residuals;
    beta      = L.beta;
end

%% Setup SSM Model
Mdl = ssm(@(params)Example_DieboldLi(params,yields,maturities));

%% Initialize SSM Model with 2-Step Fit
A0 = EstMdlVAR.AR{1};      % Get the VAR(1) matrix (stored as a cell array)
A0 = A0(:);                % Stack it columnwise
Q0 = EstMdlVAR.Covariance; % Get the VAR(1) estimated innovations covariance matrix
B0 = [sqrt(Q0(1,1)); 0; 0; sqrt(Q0(2,2)); 0; sqrt(Q0(3,3))];
H0 = cov(residuals);       % Sample covariance matrix of VAR(1) residuals
D0 = sqrt(diag(H0));       % Diagonalize the D matrix
mu0 = mean(beta)';
param0 = [A0; B0; D0; mu0; lambda0];

%% Estimate SSM Parameters
options = optimoptions('fminunc','MaxFunEvals',25000,'algorithm','quasi-newton', ...
    'TolFun' ,1e-8,'TolX',1e-8,'MaxIter',1000,'Display','off');

[EstMdlSSM,SSMParams] = estimate(Mdl,yields,param0,'Display','off', ...
    'options',options,'Univariate',true);

lambda = SSMParams(end);        % Get the estimated decay rate    
mu = SSMParams(end-3:end-1)';   % Get the estimated factor means

%% Estimate states by calculating "Deflated Yields"
intercept = EstMdlSSM.C * mu';
deflatedYields = yields - intercept';
deflatedStates = smooth(EstMdlSSM,deflatedYields);
estimatedStates = deflatedStates + mu;
