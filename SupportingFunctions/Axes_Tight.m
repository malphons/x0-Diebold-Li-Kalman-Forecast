function Axes_Tight(h_Axis,x,y,xborders,yborders,NumOfXTicks)

%% Input Checking
if nargin < 4
   xborders = 0.01;
   yborders = 0.01;
   NumOfXTicks = 10;
end

%% Setup Key Axis Parameters
x_Min = min(x);
x_Max = max(x);

y_Min = min(y);
y_Max = max(y);

%% Setup X-Axis Ticks
x_Step = floor((max(x) - min(x))/NumOfXTicks);
x      = min(x):x_Step:max(x);
x_STR  = num2cell(x);
set(h_Axis,'Xtick',x,'XtickLabel',x_STR)
xlabel(h_Axis,'Dates')

%% Tighten Axis
axis(h_Axis,[x_Min+xborders*x_Min x_Max+xborders*x_Max y_Min+yborders*y_Min y_Max+yborders*y_Max])