function change_pushbutton_color(gcf, gcbo)
df_color = '#f0f0f0';
default_color = sscanf(df_color(2:end),'%2x%2x%2x',[1 3])/255;
PushAndRadioButtons = findall(gcf,'Style','Pushbutton');
set(PushAndRadioButtons,'Backgroundcolor',default_color);
set(gcbo,'Backgroundcolor','r');