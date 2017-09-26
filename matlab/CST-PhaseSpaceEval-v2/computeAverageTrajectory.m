function [nps_splines, np_id, ntime_lim] = computeAverageTrajectory(Tsample, p_id, ps_splines, time_lim)

n = length(ps_splines.p_x_s);
smpls = length(Tsample);

ax = zeros(n,smpls);
ay = zeros(n,smpls);
az = zeros(n,smpls);
anpx = zeros(n,smpls);
anpy = zeros(n,smpls);
anpz = zeros(n,smpls);


for k = 1:n
    mask = ~(time_lim.p_time_min{k} <= Tsample &...
        Tsample <= time_lim.p_time_max{k});
    tsmp = Tsample;
    tsmp(mask) = NaN(sum(mask),1);
    ax(k,:) = ppval(ps_splines.p_x_s{k},tsmp);
    ay(k,:) = ppval(ps_splines.p_y_s{k},tsmp);
    az(k,:) = ppval(ps_splines.p_z_s{k},tsmp);
    
    anpx(k,:) = ppval(ps_splines.p_npx_s{k},tsmp);
    anpy(k,:) = ppval(ps_splines.p_npy_s{k},tsmp);
    anpz(k,:) = ppval(ps_splines.p_npz_s{k},tsmp);
end

ax = mean(ax,1,'omitnan');
ay = mean(ay,1,'omitnan');
az = mean(az,1,'omitnan');

anpx = mean(anpx,1,'omitnan');
anpy = mean(anpy,1,'omitnan');
anpz = mean(anpz,1,'omitnan');

ap_time = {Tsample};

aps_data.p_x = {ax};
aps_data.p_y = {ay};
aps_data.p_z = {az};

aps_data.p_npx = {anpx};
aps_data.p_npy = {anpy};
aps_data.p_npz = {anpz};

a_spline = fitSplines(ap_time, aps_data);

nps_splines.p_x_s = [a_spline.p_x_s; ps_splines.p_x_s];
nps_splines.p_y_s = [a_spline.p_y_s; ps_splines.p_y_s];
nps_splines.p_z_s = [a_spline.p_z_s; ps_splines.p_z_s];

nps_splines.p_npx_s = [a_spline.p_npx_s; ps_splines.p_npx_s];
nps_splines.p_npy_s = [a_spline.p_npy_s; ps_splines.p_npy_s];
nps_splines.p_npz_s = [a_spline.p_npz_s; ps_splines.p_npz_s];

np_id = [-1;p_id];

ntime_lim.dtr_time_min = min(Tsample);
ntime_lim.dtr_time_max = max(Tsample);
ntime_lim.p_time_min = [min(Tsample); time_lim.p_time_min];
ntime_lim.p_time_max = [max(Tsample); time_lim.p_time_max];
end