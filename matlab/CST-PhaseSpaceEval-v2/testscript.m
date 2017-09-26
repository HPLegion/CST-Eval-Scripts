%% Set Up
filepath = './General Layout Tests/';
filename = 'starbeam2_intf_wide.txt';
des_filename = 'centraltrajectory_intf.txt';
dtr_id = 0; %id of particle following design trajectory (dtr)

%% Import Data
[p_id, p_time, ps_data] =...
    importCstTrajectories_v2(filename,filepath);


% [p_id, p_time, ps_data] =...
%     insertDesignTrajectory(p_id, p_time, ps_data, des_filename, filepath);

%% Get Splines for x y z npx npy npz
ps_splines = fitSplines(p_time, ps_data);

clear ps_data %Only work using splines from here


%% Obtain time limits for each particle and design tracejtory (dtr)
dtr_ind = 1; %Fake Design Particle Index for function to work 
time_lim = findTimeRanges(p_time, dtr_ind);

%% Compute Medium trajectory from sample and insert as design trajectory
% Tsample = 1:301;
% [ps_splines, p_id, time_lim] = computeAverageTrajectory(Tsample,p_id, ps_splines, time_lim);

%% Determine Design trajectory index
dtr_ind = find([p_id{:}] == dtr_id); %find dtr Matlab index

clear p_id dtr_id
clear p_time

phaseSpacePlotter(time_lim, ps_splines, dtr_ind,filename)