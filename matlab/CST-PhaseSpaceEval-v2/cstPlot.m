function cstPlot(filename)
%% Set Up
%filename = 'starbeam2_intf_cone.txt';
dtr_id = 0; %id of particle following design trajectory (dtr)

%% Import Data
[p_id, p_time, ps_data] =...
    importCstTrajectories_v2(filename);
dtr_ind = find([p_id{:}] == dtr_id); %find dtr Matlab index

clear p_id dtr_id

%% Get Splines for x y z npx npy npz
ps_splines = fitSplines(p_time, ps_data);

clear ps_data %Only work using splines from here

%% Obtain time limits for each particle and design tracejtory (dtr)
time_lim = findTimeRanges(p_time, dtr_ind);

clear p_time
phaseSpacePlotter(time_lim, ps_splines, dtr_ind,filename)