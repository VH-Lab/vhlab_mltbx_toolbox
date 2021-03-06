function b = eqtot(x,y)

% vlt.data.eqtot
%
%   B = vlt.data.eqtot(X,Y)
%
%  Returns vlt.data.eqemp(X,Y), except that if the result is an array of boolean values,
%  the logical AND of all the results is returned.
%
%  Example:  vlt.data.eqtot([4 4 4],[4 4 4]) = 1, vlt.data.eqtot([1],[1 1]) = 1
%
%  See also:  vlt.data.eqemp, EQ

b=double(vlt.data.eqemp(x,y));
b=prod(reshape(b,1,prod(size(b))));
