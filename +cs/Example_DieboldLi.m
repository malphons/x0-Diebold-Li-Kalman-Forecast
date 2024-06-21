function [A,B,C,D,mean0,cov0,stateType,deflatedYield] = Example_DieboldLi(param, yield, maturity)
%EXAMPLE_DIEBOLDLI Diebold-Li yields-only model parameter mapping example
%
% Syntax:
%
%   [A,B,C,D,mean0,cov0,stateType,deflatedYield] = ...
%                                 Example_DieboldLi(param,yield,maturity)
%
% Note:
%
%   This mapping function may be called directly with the three inputs shown 
%   above.  However, when used to implicitly create an SSM model, and for 
%   subsequent estimation, this function is parameterized as an anonymous 
%   function which accepts a single column vector of estimated parameters:
%
%   f = @(param) Example_DieboldLi(param, yield, maturity)
%
%   Also, this function is only in support of the Diebold-Li example. It may 
%   change in a future release.
%
% Description:
%
%   For observation vector y(t) and state vector x(t), create a state-space 
%   model (SSM) of the form:
%
%   State equation:       x(t) = A * x(t-1) + B * u(t)
%   Observation equation: y(t) = C * x(t)   + D * e(t)
%
%   where u(t) and e(t) are uncorrelated, unit-variance white noise vector
%   processes.  In this example, there are three factors (states) and so x(t)
%   is a 3-by-1 vector and A is a 3-by-3 state transition matrix.  The
%   dimension of the observed yield vector, y(t), is determined by the
%   number of maturities included in the time series of yield curves.
%
%   To support the Diebold-Li example, the SSM model is created implicitly 
%   by specifying this function as the function that maps the input column
%   vector of parameters to the SSM model matrices A, B, C, and D.  
%
%   Moreover, this mapping function also imposes constraints on the covariance
%   matrices of the noise processes such that the non-diagonal covariance 
%   matrix of u(t) is Q = B*B' and the diagonal covariance matrix of e(t) 
%   is H = D*D'.  This mapping function also accounts for the means of the
%   three factors (states, x(t)) and deflates the input observed yields y(t)
%   to estimate the factor offsets.
%

% Copyright 2014 The MathWorks, Inc.

%
% Initialize some basic dimensions of the model.
%

numFactors    = 3;              % number of factors in the Diebold-Li "yields-only" model
numMaturities = size(yield,2);  % number of maturities (columns) in yield data 

%
% Unpack the decay rate parameter stored in the last element of the input
% parameter vector and use it to parameterize the C matrix of the observation 
% equation.  Note that when viewed as a regression model, the C matrix of 
% the observation equation may also be interpreted as a matrix of predictors, 
% and would typically be denoted as "X".
%

lambda = param(end);  % decay rate parameter is stored in the last element
C = [ones(size(maturity)) (1 - exp(-lambda*maturity))./(lambda*maturity) ...
    ((1 - exp(-lambda*maturity))./(lambda*maturity) - exp(-lambda*maturity))];

%
% Unpack the input parameter column vector and create the model parameter
% matrices A, B, and D.  Note that the C matrix has already been parameterized 
% as a function of the estimated decay rate parameter.
%

A    = zeros(numFactors);        % pre-allocate square matrix A
A(:) = param(1:numFactors^2);    % pack parameters into A columnwise 

numelB = numFactors*(numFactors+1)/2;
mask = tril(true(numFactors));
B = zeros(numFactors); 
B(mask) = param((numFactors^2 + 1):(numFactors^2 + numelB));

iOffset = numel(A) + numelB;     % last parameter index of the B matrix
D = diag(param((iOffset + 1):(iOffset + numMaturities)));

%
% Compute the intercepts (factor means) and deflate the input yields.
%

intercept = C * param((iOffset + numMaturities + 1):(end - 1));
deflatedYield = bsxfun(@minus, yield, intercept');

%
% Initialize some placeholders not used in this example, but needed to allow
% for the deflated yield data.
%

mean0     = [];
cov0      = [];
stateType = [];