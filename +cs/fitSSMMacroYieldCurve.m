function [EstMdlMacro,estParamsMacro,EstParamCovMacro] = fitSSMMacroYieldCurve(yields,maturities)

%% Input Checking
if nargin == 0
    
    L1 = cs.loadDiebolLiData();
    yields = L1.yields;
    maturities = L1.maturities;
    DataTable = L1.DataTable;
    
    L2 = load('TwoStepModel.mat');
    lambda0   = L2.lambda0;
    beta      = L2.beta;
    residuals = L2.residuals;
    
    L3 = load('SSMModel.mat');
    EstMdlSSM = L3.EstMdlSSM;
    lambda    = L3.lambda;
end

%% Reload Model
reload = false;

%% Setup Data
% Load data
macro = [DataTable.CU, DataTable.FFR, DataTable.PI];

% Variable dimensions
numBonds = size(yields,2);
numMacro = size(macro,2);
numStates = 3 + numMacro;

%% Setup Macro Model
Mdl0 = estimate(varm(numStates,1), [beta,macro]);
A0 = Mdl0.AR{1};
B0 = chol(Mdl0.Covariance,'lower');
D0 = std(residuals);
mu0 = [mean(beta),mean(macro,'omitnan')];
p0Macro = [A0(:); nonzeros(B0); D0(:); mu0(:); lambda0];

%% Fit Model
options = optimoptions('fminunc','MaxIterations',1000,'MaxFunctionEvaluations',50000);
MdlMacro = ssm(@(params) cs.Example_YieldsMacro(params,yields,macro,maturities));

if reload
    [EstMdlMacro,estParamsMacro,EstParamCovMacro] = estimate(MdlMacro,[yields,macro],p0Macro,...
        'Display','off','options',options,'Univariate',true);
else
    L = load('SSMMacroModel.mat','EstMdlMacro','estParamsMacro','estParamsMacro');
    EstMdlMacro = L.EstMdlMacro;
    estParamsMacro = L.estParamsMacro;
    EstParamCovMacro = L.estParamsMacro;
end