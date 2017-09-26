% function [p_x_s, p_y_s, p_z_s, p_npx_s, p_npy_s, p_npz_s] =...
%     fitSplines(p_time, p_x, p_y, p_z, p_npx, p_npy, p_npz)
function ps_splines = fitSplines(p_time, ps_data)

p_x_s = fitBlock(p_time, ps_data.p_x);
p_y_s = fitBlock(p_time, ps_data.p_y);
p_z_s = fitBlock(p_time, ps_data.p_z);
p_npx_s = fitBlock(p_time, ps_data.p_npx);
p_npy_s = fitBlock(p_time, ps_data.p_npy);
p_npz_s = fitBlock(p_time, ps_data.p_npz);

% Put all phase space splines in one struct
ps_splines = struct('p_x_s', {p_x_s}, 'p_y_s', {p_y_s}, 'p_z_s', {p_z_s},...
    'p_npx_s', {p_npx_s}, 'p_npy_s', {p_npy_s}, 'p_npz_s', {p_npz_s});
end

function pp = fitBlock(t_cell, x_cell)
n = length(t_cell);
pp = cell(n,1);
parfor k = 1:n
    pp{k} = spline(t_cell{k},x_cell{k});
end
end