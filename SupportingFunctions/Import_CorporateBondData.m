function Bonds = Import_CorporateBondData(FileName,SheetName)

%% Input Checking
if nargin == 0
    FileName  = 'TheData\PotentialBondPortfolio_20140113.xls';
    SheetName = 'CorporateBonds';
end

Bonds                 = readtable(FileName,'Sheet',SheetName);
Bonds.Rating          = ordinal(Bonds.Rating,{'D','CCC','CC','B','BB','BBB','A','AA','AAA'});
Bonds.CurrentYield    = Bonds.CurrentYield/100;
Bonds.Coupon          = Bonds.Coupon/100;
Bonds.MaturityNum     = datenum(Bonds.Maturity);
Bonds.TradeDate      = repmat({'01/13/2014'},length(Bonds.MaturityNum),1);
Bonds.TradeDateNum   = datenum(Bonds.TradeDate,'mm/dd/yyyy');
Bonds.InstrumentType  = repmat({'Bond'},length(Bonds.TradeDateNum),1);
Bonds.CouponPeriod    = repmat(2,length(Bonds.TradeDateNum),1);
