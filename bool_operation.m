function [outputArg1,outputArg2] = bool_operation(polygons,operator)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

pos = 1:length(polygons);
ns = cell(arrayfun(@(p)(strcat('pol', num2str(p))),pos, 'UniformOutput', false));
sf = strjoin(ns, '-');
ns = char(ns);

end

