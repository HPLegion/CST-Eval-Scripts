function [newp_id, newp_time, newps_data] =...
    insertDesignTrajectory(p_id, p_time, ps_data, des_filename, varargin)

if ~isempty(varargin)
    filepath = varargin{1};
else
    filepath ='';
end

[~, dp_time, dps_data] =...
    importCstTrajectories_v2(des_filename,filepath);

newp_id = [-1;p_id]; % Identify Design Trajectory with ID -1
%Insert design trajectory data before all other data
newp_time = [dp_time;p_time];
newps_data.p_x = [dps_data.p_x;ps_data.p_x];
newps_data.p_y = [dps_data.p_y;ps_data.p_y];
newps_data.p_z = [dps_data.p_z;ps_data.p_z];
newps_data.p_npx = [dps_data.p_npx;ps_data.p_npx];
newps_data.p_npy = [dps_data.p_npy;ps_data.p_npy];
newps_data.p_npz = [dps_data.p_npz;ps_data.p_npz];
end

