%% Set Up
filepath = 'M:\ANALYSIS\v4s-emittance-offset-xy\split_traj-plain-offset\';
filename = '12C1p_gauss-30keV-en0.01_x_-15_y_0.txt';
% des_filename = 'centraltrajectory_intf.txt';
dtr_id = 0; %id of particle following design trajectory (dtr)
% SID =0;

x = [-15,-10,-5,0,5,10,15];
y = [0,5,10,15];
[X,Y] = meshgrid(x,y);
emit_x = zeros(size(X));
emit_y = zeros(size(X));
n_lost = zeros(size(X));
zq = zeros(size(X));
npxq = zeros(size(X));
npyq = zeros(size(X));
npzq = zeros(size(X));

cutoff = 5; %%Cutoff point to reduce computational efforts
for k = 1:numel(X)
    disp(k)
    filename = ['12C1p_gauss-30keV-en0.01_x_', num2str(X(k)),'_y_' num2str(Y(k)),'.txt'];
    %% Import Data
    [p_id, p_sid, p_time, ps_data] =...
        importCstTrajectoriesPIC(filename,filepath);
    
    % [fp_id, fp_sid, fp_time, fps_data, ffirst_index]...
    %     = filterPIC(SID, p_id, p_sid, p_time, ps_data);
    
    % [p_id, p_time, ps_data] =...
    %     insertDesignTrajectory(p_id, p_time, ps_data, des_filename, filepath);
    
    %Reduce Data since only late data is interesting right now
    for ii = 1:length(p_id)
        p_time{ii} = p_time{ii}(1:cutoff);
        ps_data.p_x{ii} = ps_data.p_x{ii}(1:cutoff);
        ps_data.p_y{ii} = ps_data.p_y{ii}(1:cutoff);
        ps_data.p_z{ii} = ps_data.p_z{ii}(1:cutoff);
        ps_data.p_npx{ii} = ps_data.p_npx{ii}(1:cutoff);
        ps_data.p_npy{ii} = ps_data.p_npy{ii}(1:cutoff);
        ps_data.p_npz{ii} = ps_data.p_npz{ii}(1:cutoff);
    end
    
    dtr_ind = find([p_id{:}] == dtr_id); %find dtr Matlab index
    clear p_id %dtr_id
    
    %% Get Splines for x y z npx npy npz
    ps_splines = fitSplines(p_time, ps_data);
    
    clear ps_data %Only work using splines from here
    
    %% Obtain time limits for each particle and design tracejtory (dtr)
    time_lim = findTimeRanges(p_time, dtr_ind);
    
    Tq = 3; % query time is close to end of simulation
    [ts_coordinates, n_lost(k)] = evalPhaseSpace(Tq, time_lim, ps_splines, dtr_ind);
    [emit_x(k), emit_y(k)] = emittance(ts_coordinates);
    zq(k) = ppval(ps_splines.p_z_s{dtr_ind},Tq);
    npxq(k) = ppval(ps_splines.p_npx_s{dtr_ind},Tq);
    npyq(k) = ppval(ps_splines.p_npy_s{dtr_ind},Tq);
    npzq(k) = ppval(ps_splines.p_npz_s{dtr_ind},Tq);
end
    
plain_in_emit_x = emit_x;
plain_in_emit_y = emit_y;
plain_in_n_lost = n_lost;
plain_in_zq = zq;
plain_in_npxq = npxq;
plain_in_npyq = npyq;
plain_in_npzq = npzq;

    
    % clear p_time
%     phaseSpacePlotter(time_lim, ps_splines, dtr_ind,filename)
    
    %% record emittances
%     nt = 30;
%     Tq=linspace(1,590,nt);
%     emit_x = zeros(nt,1);
%     emit_y = zeros(nt,1);
%     n_lost = zeros(nt,1);
%     zq = zeros(nt,1);
%     npxq = zeros(nt,1);
%     npyq = zeros(nt,1);
%     npzq = zeros(nt,1);
%     for k =1:length(Tq)
%         disp(k)
%         tic;
%         [ts_coordinates, n_lost(k)] = evalPhaseSpace(Tq(k), time_lim, ps_splines, dtr_ind);
%         [emit_x(k), emit_y(k)] = emittance(ts_coordinates);
%         zq(k) = ppval(ps_splines.p_z_s{dtr_ind},Tq(k));
%         npxq(k) = ppval(ps_splines.p_npx_s{dtr_ind},Tq(k));
%         npyq(k) = ppval(ps_splines.p_npy_s{dtr_ind},Tq(k));
%         npzq(k) = ppval(ps_splines.p_npz_s{dtr_ind},Tq(k));
%         toc
%     end
    
    %%
%     plain_m15.emit_x = emit_x;
%     plain_m15.emit_y = emit_y;
%     plain_m15.zq = zq;
%     plain_m15.n_lost = n_lost;
%     plain_m15.npxq = npxq;
%     plain_m15.npyq = npyq;
%     plain_m15.npzq = npzq;
%     msgbox('done')
    
