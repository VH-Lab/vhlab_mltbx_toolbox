function i_out = interval_subtract(i_in, i_sub)
% INTERVAL_SUBTRACT - remove an interval from a larger interval
% 
% I_OUT = vlt.math.interval_subtract(I_IN, I_SUB)
%
% Given a matrix of intervals I_IN = [T1_0 T1_1; T2_0 T2_1 ; ... ] 
% where T is increasing (that is, where T(i)_0 > T(i-1)_0 and Ti_0<Ti_1 for all i),
% produce another matrix of intervals I_OUT that excludes the interval I_SUB = [S0 S1].
%
% Examples:
%    i_out = vlt.math.interval_subtract([0 10],[1 2]) % yields [ 0 1; 2 10]
%    i_out = vlt.math.interval_subtract([0 10],[0 2]) % yields [ 2 10]
%

 % let's start out assuming we can operate on the intervals in order; we probably can't

  % we have many possibilities that might require subtraction in [ti_0 ti_1]:
  %    s0 might be inside [ti_0,ti_1). 
  %        Then, we have to break the interval into one piece [ti_0 s0].
  %        If s1 is also in [ti_0,ti_1), then we also have to add [s1 ti_1]
  %        else (if s1 is bigger than ti_1), we don't add this piece
  %    s0 might be less than ti_0 but s1 might be inside (ti_0,ti_1]
  %    s0 might be less than ti_0 but s1 might be greater than ti_1

 % some error checking

if isempty(i_sub),
	i_out = i_in;
	return;
end;

if numel(i_sub)~=2,
	error(['The interval to subtract must be a 2-element vector.']);
end;

if any(i_in(:,2)-i_in(:,1) <= 0)
	error(['In all intervals ti_0 must be less than ti_1']);
end;

if any (i_in(2:end,1)-i_in(1:end-1,2) <= 0),
	error(['In all input intervals I_IN, ti_1 must be greater than than t(i-1)_2']);
end

s0 = i_sub(1);
s1 = i_sub(2);

if s1-s0 <=0,
	error(['S0 must be less than S1']);
end;



s0_inside = (s0 >= i_in(:,1)) & (s0 < i_in(:,2));
s1_inside = (s1 >= i_in(:,1)) & (s1 < i_in(:,2));

s0_less_but_s1_greater = (s0 < i_in(:,1)) & (s1 > i_in(:,2));
s0_less_but_s1_inside  = (s0 < i_in(:,1)  & s1_inside);

i_out = [];

for i=1:size(i_in,1),
	out_here = [ i_in(i,:) ];
	if s0_inside(i),
		out_here = [ i_in(i,1) s0 ];
		if s1_inside(i),
			out_here = [out_here ; s1 i_in(i,2)];
		end;
	elseif s1_inside(i),
		out_here = [ s1 i_in(i,2) ];
	elseif s0_less_but_s1_greater(i), % we have to cut this whole thing out
		out_here = [];
	else, % we leave it alone
	end;
	i_out = [i_out; out_here];
end


