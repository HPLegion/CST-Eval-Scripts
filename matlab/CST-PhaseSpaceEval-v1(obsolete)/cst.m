tic
clear
importCstTrajectories
toc
tic
findDesignTrajectory
toc
tic
transformCoordinates
toc
% 
% figure
% hold on
% for k=1:n
%     len = min(dtr_length,length(p_pos_tr{k}));
%     plot(p_pos_tr{k}(1:len,1),p_pos_tr{k}(1:len,2))
% end

% m = 12* 1.6726219e-27; %kg
% c = 299792458; %m/s
% figure
% for ind = 1:65
%     pause(5/1000)
%     clf
%     grid on
%     xlim([-30,30])
%     ylim([-30,30])
%     pbaspect([1 1 1])
%     title([' z = ',num2str(p_pos{1}(ind,3))])
% for k=1:n
%     hold on
%     %quiver(p_pos_tr{k}(ind,1),p_pos_tr{k}(ind,2),p_nmom_tr{k}(ind,1),p_nmom_tr{k}(ind,2),100000,'b')
%     %plot(p_pos_tr{k}(ind,1),p_pos_tr{k}(ind,2),'ro')
%     plot(p_pos_tr{k}(ind,2),1000*p_nmom_tr{k}(ind,2)/p_nmom_tr{k}(ind,3),'ro')
% end
% end

