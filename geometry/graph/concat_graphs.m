function [G_concat] = concat_graphs(varargin)
%concat_graphs Concatenate all n graphs
    
    G_data = table();
    G_matrix = [];
    for G=varargin{:}
        G = G{1};
        G_data = [G_data; G.Nodes];
        G_aux = full(adjacency(G));
        aux_len = length(G_aux);
        G_matrix(end+1:end+aux_len, end+1:end+aux_len) = G_aux;
    end
    G_concat = digraph(G_matrix);
    G_concat.Nodes = G_data;
end