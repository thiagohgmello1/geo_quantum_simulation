function [closest_points] = is_close(a, b, varargin)
%is_close check if two numbers are close
    defaultRTol = 1e-5;
    defaultATol = 0;

    p = inputParser;
    validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x >= 0);
    addRequired(p,'a');
    addRequired(p,'b');
    addOptional(p, 'rtol', defaultRTol, validScalarPosNum);
    addOptional(p, 'atol', defaultATol, validScalarPosNum);
    parse(p, a , b, varargin{:});

    closest_points = abs(a - b) <= p.Results.rtol * max([abs(a); abs(b)]) + p.Results.atol;
end

