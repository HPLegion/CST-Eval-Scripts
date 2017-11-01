%% Set Up
filepath = 'M:\ANALYSIS\v4s-emittance-offset-xy\';
filename = 'test.txt';
% des_filename = 'centraltrajectory_intf.txt';
dtr_id = 0; %id of particle following design trajectory (dtr)
% SID =0;

%% Import Data
[p_id, p_sid, p_time, ps_data] =...
    importCstTrajectoriesPIC(filename,filepath);

% [fp_id, fp_sid, fp_time, fps_data, ffirst_index]...
%     = filterPIC(SID, p_id, p_sid, p_time, ps_data);

% [p_id, p_time, ps_data] =...
%     insertDesignTrajectory(p_id, p_time, ps_data, des_filename, filepath);

dtr_ind = find([p_id{:}] == dtr_id); %find dtr Matlab index
clear p_id dtr_id

%% Get Splines for x y z npx npy npz
ps_splines = fitSplines(p_time, ps_data);

clear ps_data %Only work using splines from here

%% Obtain time limits for each particle and design tracejtory (dtr)
time_lim = findTimeRanges(p_time, dtr_ind);

% clear p_time
phaseSpacePlotter(time_lim, ps_splines, dtr_ind,filename)

%% record emittances
% nt = 30;
% Tq=linspace(1,590,nt);
% emit_x = zeros(nt,1);
% emit_y = zeros(nt,1);
% n_lost = zeros(nt,1);
% zq = zeros(nt,1);
% npxq = zeros(nt,1);
% npyq = zeros(nt,1);
% npzq = zeros(nt,1);
% for k =1:length(Tq)
%     disp(k)
%     tic;
%     [ts_coordinates, n_lost(k)] = evalPhaseSpace(Tq(k), time_lim, ps_splines, dtr_ind);
%     [emit_x(k), emit_y(k)] = emittance(ts_coordinates);
%     zq(k) = ppval(ps_splines.p_z_s{dtr_ind},Tq(k));
%     npxq(k) = ppval(ps_splines.p_npx_s{dtr_ind},Tq(k));
%     npyq(k) = ppval(ps_splines.p_npy_s{dtr_ind},Tq(k));
%     npzq(k) = ppval(ps_splines.p_npz_s{dtr_ind},Tq(k));
%     toc
% end
% 
% %%
% plain_m15.emit_x = emit_x;
% plain_m15.emit_y = emit_y;
% plain_m15.zq = zq;
% plain_m15.n_lost = n_lost;
% plain_m15.npxq = npxq;
% plain_m15.npyq = npyq;
% plain_m15.npzq = npzq;
% msgbox('done')