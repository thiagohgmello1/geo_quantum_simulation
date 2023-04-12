function [alpha, beta, tau] = def_periodic_structures(G, nodes, n_sides)
%def_periodic_structures calculate periodic structures in contacts

    for node=nodes
        neigs = neighbors(G, string(node));
        neig = get_contact_neigs(G, neigs);
        for neig=neigs
            allpaths(G, '26', '37', 'MaxPathLength', n_sides)
        end

    end
    
end

function contact_neigs = get_contact_neigs(G, neigs)
    contact_neigs = [];
    for neig=neigs'
        neig_properties = G.Nodes(findnode(G, neig),:);
        if neig_properties.cont
            contact_neigs = [contact_neigs neig];
        end
    end
end