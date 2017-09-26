function phaseSpacePlotter(p_pos_tr, p_nmom_tr, dtr_pos,name)
h.fig=figure;
set(h.fig,'Name',name)
% Create an axes to plot in
%axes('Position',[.15 .05 .7 .9]);
% sliders for epsilon and lambda
len = length(dtr_pos);
h.sli=uicontrol(h.fig,'Style','slider','Max',len,'Min',1,...
    'Value',1,'SliderStep',[1/(len-1) 10/(len-1)],...
    'Units','normalized','Position',[.5 .01 .48 .05]);

h.tex = uicontrol(h.fig,'Style','text','Units','normalized','Position',[.5 .1 .35 .1],...
    'String','Choose frame: 1','FontSize',14,'HorizontalAlignment','Left');

% Set up callbacks
set(h.sli,'Callback',{@slider_callback,h,p_pos_tr,p_nmom_tr, dtr_pos});

plotter(h, p_pos_tr,p_nmom_tr, dtr_pos)
end

function slider_callback(~,~,h,p_pos_tr,p_nmom_tr, dtr_pos)
plotter(h, p_pos_tr,p_nmom_tr, dtr_pos)
end

function plotter(h, p_pos_tr,p_nmom_tr, dtr_pos)
%% General Setup
index = round(h.sli.Value);
h.tex.String = ['Choose frame: ',num2str(index),', z = ',num2str(dtr_pos(index,3)),'mm'];
n = size(p_pos_tr,1);
xlimps =[-30,30];
ylimps =[-50,50];
limrs =[-30, 30];

%% x phase space
subplot(2,2,1)
hold off; plot(0,0); hold on;
for k=1:n
    plot(p_pos_tr{k}(index,1),1000*p_nmom_tr{k}(index,1)/p_nmom_tr{k}(index,3),'ro')
end

title('Phase Space x')
xlabel('x (mm)')
ylabel('x'' (mrad)')
xlim(xlimps)
ylim(ylimps)
grid on


%% y phase space
subplot(2,2,2)
hold off; plot(0,0); hold on;
for k=1:n
    plot(p_pos_tr{k}(index,2),1000*p_nmom_tr{k}(index,2)/p_nmom_tr{k}(index,3),'ro')
end

title('Phase Space y')
xlabel('y (mm)')
ylabel('y'' (mrad)')
xlim(xlimps)
ylim(ylimps)
grid on

%% real space
subplot(2,2,3)
hold off; plot(0,0); hold on;

t = linspace(0,2*pi,1000);
for r = 5:5:20
   plot(r*sin(t),r*cos(t),':','Color',[0.1, 0.1, 0.1]); 
end

for k=1:n
        plot(p_pos_tr{k}(index,1),p_pos_tr{k}(index,2),'ro')
end
title('Real Space')
xlabel('x (mm)')
ylabel('y (mrad)')
xlim(limrs)
ylim(limrs)
grid on
pbaspect([1 1 1])

%subplot(2,2,4)
end