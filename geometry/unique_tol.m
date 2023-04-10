function is_unique = unique_tol(A, varargin)
%unique_tol select unique array elements according radius tolerance
    
    defaultRadiusTol = 1e-10;
    p = inputParser;
    validScalarPosNum = @(x) isnumeric(x) && isscalar(x) && (x >= 0);
    addRequired(p,'A');
    addOptional(p, 'radius_tol', defaultRadiusTol, validScalarPosNum);
    parse(p, A, varargin{:});

    is_unique = true(1, length(A));

    if size(A, 1) > 1
        for i=1:(length(A) - 1)
            for j=(i + 1):length(A)
                if circle(A(i,:), A(j,:), p.Results.radius_tol)
                    is_unique(j) = false;
                end
            end
        end
    else
        is_unique = true;
    end
end

function inside = circle(c, p, r)
    inside = (c(1) - p(1)) ^ 2 + (c(2) - p(2)) ^ 2 <= r ^ 2;
end