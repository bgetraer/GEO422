function [vline_handle] = vline(x_values,ylimit,style)
%VLINE Plots vertical lines at given values of x for a given ylimit
%

defval('style','-')

% put in form [x1 x1 nan nan x2 x2 nan nan etc]
x1 = [x_values; nan(1,length(x_values))]; 
x2 = [x1(:)';x1(:)'];
X = x2(:);

% put in form [y1 y2 nan nan y1 y2 nan nan etc]
Y = repmat([ylimit nan nan],1,length(x_values));

vline_handle = plot(X,Y,style);
end