function y = skewgauss(x, p)
% SKEWGAUSS - calculate the skew gaussian function
%
% Y = SKEWGAUSS(X, P)
%
% Evaluates 
%    Y = a+b*exp((x-c).^2/(2*d^2))*(1+erf(e*(x-c)/sqrt(2)));
%
% a is an offset parameter; b is a height parameter above the offset;
% c is the peak location; d is the width; e is the degree of skewness (0 is none)
% 
% The parameters are specified in a vector P = [a b c d e]
% 
% See also: vlt.fit.skewgaussfit_constraints
%

a = p(1);
b = p(2);
c = p(3);
d = p(4);
e = p(5);

y = a+b*exp(-((x-c).^2)/((2*d^2))).*(1+erf(e*(x-c)/sqrt(2)));
