function edges = get_edges(gcbo, handle_str)
bounds = handle_str;
str_check = regexp(bounds,'(\d|,)*','split');
str_check = isempty([str_check{:}]);
if ~str_check || isempty(bounds)
    set(gcbo,'Backgroundcolor','r');
    edges = [];
else
    df_color = '#f0f0f0';
    default_color = sscanf(df_color(2:end),'%2x%2x%2x',[1 3])/255;
    set(gcbo,'Backgroundcolor',default_color);
    edges = str2num(bounds);
end