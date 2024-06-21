function [A,B,C,D,mean0,cov0,stateType,deflatedData] = DieboldClimateMacro(param, yields, macro, maturities)

numBonds = size(yields,2);
numMacro = size(macro,2);
numStates = 3 + numMacro;

lambda = param(end);
lambdaTau = lambda .* maturities;
expLambdaTau = exp(-lambdaTau);
loading = [ones(numBonds,1), (1 - expLambdaTau)./lambdaTau, (1 - expLambdaTau)./lambdaTau - expLambdaTau];
C = blkdiag(loading,eye(numMacro));

A    = zeros(numStates);       
A(:) = param(1:numStates^2);    

iOffset = numel(A);
numelB = numStates*(numStates+1)/2;
mask = tril(true(numStates));
B = zeros(numStates); 
B(mask) = param((iOffset + 1):(iOffset + numelB));

iOffset = iOffset + numelB;
stdev = param((iOffset + 1):(iOffset + numBonds));
D = [diag(stdev);zeros(numMacro,numBonds)];

iOffset = iOffset + numBonds;
mu = param((iOffset + 1):(iOffset + numStates));
deflatedData = [yields,macro] - (C*mu)';

mean0     = [];
cov0      = [];
stateType = [];
end