function msr = magsqrt(A)

% vlt.math.magsqrt - Magnitude square root 
%
%  MSR = vlt.math.magsqrt(A) returns the magnitude of the square root that is sign
%  appropriate.  If A(i) is negative, then -sqrt(-A(i)) is returned.
%  Otherwise, sqrt(A(i)) is returned.

msr = sqrt(A);
msr = real(msr) - imag(msr);
