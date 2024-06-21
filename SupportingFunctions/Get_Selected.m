function Selected = Get_Selected(handles)

%% Get Global Data
Data = get(handles.figure1,'UserData');

%% Setup All Key Variables before selection
Selected.Data    = Data;
Selected.handles = handles;

%% Get Selected Items
PortfolioChoice          = get(handles.DropDown_Portfolio,'String');
Selected.PortfolioChoice = PortfolioChoice{get(handles.DropDown_Portfolio,'Value')};
Scenarios                = get(handles.DropDown_StressScenario,'String');
Selected.Scenario        = Scenarios{get(handles.DropDown_StressScenario,'Value')};
Selected.PivotDays2Maturity = str2double(get(handles.Edit_PivotDays2Maturity,'String'));
Selected.StressDelta        = str2double(get(handles.Edit_Delta,'String'));

%% Setup Portfolio & Yield Curve
if strcmp(Selected.PortfolioChoice,'Investment Grade')
    Selected.YieldCurve               = Data.YieldCurve_InvestmentGrade;
    Data.Bonds_InvestmentGrade.Rating = Nominal2Cell(Data.Bonds_InvestmentGrade.Rating);
    Selected.Portfolio                = Data.Bonds_InvestmentGrade;
    Selected.PortfolioColName         = fieldnames(Selected.Portfolio);
    Selected.PortfolioColName         = Selected.PortfolioColName(1:end-1);
    RatingOptions                     = nominal({'D','CCC','CC','B','BB','BBB','A','AA','AAA'});
    AvailableRatings                  = nominal(unique(Selected.Portfolio.Rating));
    Idx_2Save                         = [];
    for i = 1:length(AvailableRatings)
        Idx_2Save = [Idx_2Save find(RatingOptions == AvailableRatings(i),1,'first')]; %#ok
    end
    Ratings2Use                       = Nominal2Cell(RatingOptions(Idx_2Save));
    
    Selected.Portfolio.Rating         = ordinal(Selected.Portfolio.Rating,Ratings2Use);

elseif strcmp(Selected.PortfolioChoice,'High Yield')
    Selected.YieldCurve               = Data.YieldCurve_InvestmentGrade;
    Data.Bonds_HighYield.Rating       = Nominal2Cell(Data.Bonds_HighYield.Rating);
    Selected.Portfolio                = Data.Bonds_HighYield;
    Selected.PortfolioColName         = fieldnames(Data.Bonds_HighYield);
    Selected.PortfolioColName         = Selected.PortfolioColName(1:end-1);
    RatingOptions                     = nominal({'D','CCC','CC','B','BB','BBB','A','AA','AAA'});
    AvailableRatings                  = nominal(Selected.Portfolio.Rating);
    Idx_2Save                         = [];
    for i = 1:length(AvailableRatings)
        Idx_2Save = [Idx_2Save find(RatingOptions == AvailableRatings(i),1,'first')]; %#ok
    end
    Ratings2Use                       = Nominal2Cell(RatingOptions(Idx_2Save));
    Selected.Portfolio.Rating         = ordinal(Selected.Portfolio.Rating,Ratings2Use);
else
end