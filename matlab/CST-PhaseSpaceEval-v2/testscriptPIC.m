%% Set Up
filepath = 'M:\evaltest\split\';
filename = '12C_gauss_rx_3_ry_3_x_0_y_0.txt';
des_filename = 'centraltrajectory_intf.txt';
dtr_id = 0; %id of particle following design trajectory (dtr)
SID =0;

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