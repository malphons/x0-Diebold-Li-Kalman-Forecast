function compareARInteractions(hAxis1,hAxis2)

%% Input Data
if nargin == 0
    L1 = load('TwoStepModel.mat');
    EstMdlVAR = L1.EstMdlVAR;
    L2 = load('SSMModel.mat');
    EstMdlSSM = L2.EstMdlSSM;
    figure;
    hAxis1 = subplot(2,1,1);
    hAxis2 = subplot(2,1,2);
elseif nargin == 2
    L1 = load('TwoStepModel.mat');
    EstMdlVAR = L1.EstMdlVAR;
    L2 = load('SSMModel.mat');
    EstMdlSSM = L2.EstMdlSSM;    
end

%% Visualize
imagesc(hAxis1,1:3,1:3,EstMdlVAR.AR{1});
hAxis1.XTick = 1:3; 
hAxis1.YTick = 1:3;
hAxis1.XTickLabel = {'L(t-1)','S(t-1)','C(t-1)'};
hAxis1.YTickLabel = {'L(t)','S(t)','C(t)'};
hold(hAxis1,'on')
for i = 1:3
    for j = 1:3
        text(hAxis1,i,j,num2str(EstMdlVAR.AR{1}(i,j),'%10.2f'),'Color','white')
    end
end
        
colorbar(hAxis1)
title(hAxis1,'Vector Autoregressive Estimates')

imagesc(hAxis2,1:3,1:3,EstMdlSSM.A);
hAxis2.XTick = 1:3; 
hAxis2.YTick = 1:3;
hAxis2.XTickLabel = {'L(t-1)','S(t-1)','C(t-1)'};
hAxis2.YTickLabel = {'L(t)','S(t)','C(t)'};
for i = 1:3
    for j = 1:3
        text(hAxis2,i,j,num2str(EstMdlSSM.A(i,j),'%10.2f'),'Color','white')
    end
end
colorbar(hAxis2)
title(hAxis2,'State Space Model')
% colormap('jet')