function phaseSpacePlotter(time_lim, ps_splines, dtr_ind,name)
h.fig=figure;
set(h.fig,'Name',name)
% Create an axes to plot in
%axes('Position',[.15 .05 .7 .9]);
% sliders for epsilon and lambda
h.sli=uicontrol(h.fig,'Style','slider','Max',time_lim.dtr_time_max,'Min',time_lim.dtr_time_min,...
    'Value',max(time_lim.dtr_time_min,1),...%'SliderStep',[1/(T0-1) 10/(len-1)],...
    'Units','normalized','Position',[.0 .0 .5 .05]);

% uicontrol(h.fig,'Style','text','Units','normalized','Position',[.5 .1 .5 .05],...
%     'String','Choose frame: ','FontSize',12,'HorizontalAlignment','Left');

h.texT = uicontrol(h.fig,'Style','text','Units','normalized','Position',[.52 .01 .5 .049],...
    'FontSize',14,'HorizontalAlignment','Left','String','xxx');

% h.texZ = uicontrol(h.fig,'Style','text','Units','normalized','Position',[.5 .25 .5 .05],...
%     'FontSize',14,'HorizontalAlignment','Left','String','xxx');
% 
% h.texEMX = uicontrol(h.fig,'Style','text','Units','normalized','Position',[.5 .2 .5 .05],...
%     'FontSize',14,'HorizontalAlignment','Left','String','xxx');
% 
% h.texEMY = uicontrol(h.fig,'Style','text','Units','normalized','Position',[.5 .15 .5 .05],...
%     'FontSize',14,'HorizontalAlignment','Left','String','xxx');

% Set up callbacks
set(h.sli,'Callback',{@slider_callback,h,time_lim, ps_splines, dtr_ind});

plotter(h,time_lim, ps_splines, dtr_ind)
end

function slider_callback(~,~,h,time_lim, ps_splines, dtr_ind)
plotter(h, time_lim, ps_splines, dtr_ind)
end

function plotter(h, time_lim, ps_splines, dtr_ind)
%% General Setup
t_slider = h.sli.Value;
tic;
[ts_coordinates, n_lost] = evalPhaseSpace(t_slider, time_lim, ps_splines, dtr_ind);
toc;
[emit_x, emit_y] = emittance(ts_coordinates);
h.texT.String = ['T = ',num2str(t_slider),' ns | Lost: ',num2str(n_lost)];
% h.texZ.String = ['z = ',num2str(ppval(ps_splines.p_z_s{dtr_ind},t_slider)),' mm'];
% h.texEMX.String = ['em_x_rms = ',num2str(emit_x),' mm mrad'];
% h.texEMY.String = ['em_y_rms = ',num2str(emit_y),' mm mrad'];

xlimps =[-30,30];
ylimps =[-60,60];
limrs =[-30, 30];

%% x phase space
subplot(2,2,1)
hold off; plot(0,0); hold on;

plot(ts_coordinates.x,ts_coordinates.xprime,'ro')

title({'Phase Space x',[' \epsilon_{x,rms} = ',num2str(emit_x),' mm mrad']})
xlabel('x (mm)')
ylabel('x'' (mrad)')
xlim(xlimps)
ylim([-3*std(ts_coordinates.xprime,'omitnan'),3*std(ts_coordinates.xprime,'omitnan')])
grid on


%% y phase space
subplot(2,2,2)
hold off; plot(0,0); hold on;

plot(ts_coordinates.y,ts_coordinates.yprime,'ro')

title({'Phase Space y',[' \epsilon_{y,rms} = ',num2str(emit_y),' mm mrad']})
xlabel('y (mm)')
ylabel('y'' (mrad)')
xlim(xlimps)
ylim([-3*std(ts_coordinates.yprime,'omitnan'),3*std(ts_coordinates.yprime,'omitnan')])
grid on

%% real space
subplot(2,2,3)
hold off; plot(0,0); hold on;

t = linspace(0,2*pi,1000);
for r = 5:5:20
   plot(r*sin(t),r*cos(t),':','Color',[0.1, 0.1, 0.1]); 
end

plot(ts_coordinates.x,ts_coordinates.y,'ro')

title({'Real Space';['z = ',num2str(ppval(ps_splines.p_z_s{dtr_ind},t_slider)),' mm']})
xlabel('x (mm)')
ylabel('y (mm)')
xlim(limrs)
ylim(limrs)
grid on
pbaspect([1 1 1])

subplot(2,2,4)
hold off; plot(0,0); hold on;

plot(ts_coordinates.l,1000*ts_coordinates.delta,'ro')

title('Longitudinal Phase Space')
xlabel('l (mm)')
ylabel('\delta (per mil)')
xlim([-3*std(ts_coordinates.l,'omitnan'),3*std(ts_coordinates.l,'omitnan')])
ylim([-3*std(1000*ts_coordinates.delta,'omitnan'),3*std(1000*ts_coordinates.delta,'omitnan')])
grid on
end