function apply_params(model, params)
%apply_params Apply equation parameters

specifyCoefficients(model, 'm', params.m, 'd', params.d,...
    'c', params.c, 'a', params.a, 'f', params.f);
end

