function edges = read_edit_text(gcbo, handle_str, change_color)
if nargin < 3
    change_color = true;
end
bounds = handle_str;
str_check = regexp(bounds,'(\d|,)*','split');
str_check = isempty([str_check{:}]);
if ~str_check || isempty(bounds)
    if change_color
        set(gcbo,'Backgroundcolor','r');
    end
    edges = [];
else
    if change_color
        df_color = '#f0f0f0';
        default_color = sscanf(df_color(2:end),'%2x%2x%2x',[1 3])/255;
        set(gcbo,'Backgroundcolor',default_color);
    end
    edges = str2num(bounds);
end