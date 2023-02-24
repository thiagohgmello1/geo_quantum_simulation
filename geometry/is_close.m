function [are_close] = is_close(a, b, rtol)
%is_close check if two numbers are close

    if nargin < 3
        rtol = 1e-5;
    end
    are_close = abs(a - b) <= rtol * max([abs(a), abs(b)]);
end

