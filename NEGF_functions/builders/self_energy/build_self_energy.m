function sigma = build_self_energy(G, epsilon, t, energy, eta, stop_cond, system, a, varargin)
%build_self_energy build self energy matrices for contacts
    
    defaultMethod = 0;
    p = inputParser;
    addRequired(p,'G');
    addRequired(p,'epsilon');
    addRequired(p,'t');
    addRequired(p,'energy');
    addRequired(p,'eta');
    addRequired(p,'stop_cond');
    addRequired(p,'system');
    addRequired(p,'a');
    addOptional(p, 'method', defaultMethod);
    parse(p, G, epsilon, t, energy, eta, stop_cond, system, a, varargin{:});
    method = p.Results.method;
    
    contact_params = [system.boundaries.dir.params];
    contact_trans_dir = vertcat(contact_params.trans_dir);
%     contact_pot_offset = vertcat(contact_params.r);
    [alpha, beta, tau] = def_periodic_structures(G, contact_trans_dir, a, epsilon, t);
    
    if method == 1
%         [sigma, SGF] = recurrent_method(G, alpha, beta, tau, energy, eta, stop_cond);
        [sigma, SGF] = recurrent_method2(G, alpha, beta, tau, energy, eta, stop_cond);
    else
        [sigma, SGF] = semi_analytical_method(alpha, beta, energy);
    end
end










