function myslider(pos,mom)
fig=figure(100);
set(fig,'Name','Image','Toolbar','figure',...
    'NumberTitle','off')
% Create an axes to plot in
axes('Position',[.15 .05 .7 .9]);
% sliders for epsilon and lambda
slider1_handle=uicontrol(fig,'Style','slider','Max',150,'Min',1,...
    'Value',2,'SliderStep',[1/(150-1) 10/(150-1)],...
    'Units','normalized','Position',[.02 .02 .14 .05]);
uicontrol(fig,'Style','text','Units','normalized','Position',[.02 .07 .14 .04],...
    'String','Choose frame');
% Set up callbacks
vars=struct('slider1_handle',slider1_handle);
set(slider1_handle,'Callback',{@slider1_callback,vars,pos,mom});
plotterfcn(vars,pos,mom)
% End of main file

% Callback subfunctions to support UI actions
function slider1_callback(~,~,vars,pos,mom)
    % Run slider1 which controls value of epsilon
    plotterfcn(vars,pos,mom)

function plotterfcn(vars,pos,mom)
    % Plots the image
%     imshow(vars.B(:,:,get(vars.slider1_handle,'Value')));
%     title(num2str(get(vars.slider1_handle,'Value')));
    ind = get(vars.slider1_handle,'Value');
    p_pos_tr = pos;
    p_nmom_tr = mom;
    hold off
    plot(0,0,'.')
    hold on
    grid on
    xlim([-30,30])
    ylim([-30,30])
    pbaspect([1 1 1])
  %  title([' z = ',num2str(p_pos{1}(ind,3))])
  n =17;
    for k=1:n
        %quiver(p_pos_tr{k}(ind,1),p_pos_tr{k}(ind,2),p_nmom_tr{k}(ind,1),p_nmom_tr{k}(ind,2),100000,'b')
        plot(p_pos_tr{k}(ind,1),p_pos_tr{k}(ind,2),'ro')
        %plot(p_pos_tr{k}(ind,2),1000*p_nmom_tr{k}(ind,2)/p_nmom_tr{k}(ind,3),'ro')
    end