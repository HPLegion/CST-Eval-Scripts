function [fp_id, fp_sid, fp_time, fps_data, ffirst_index]...
    = filterPIC(SID, p_id, p_sid, p_time, ps_data)

mask = (p_sid == SID);
ffirst_index = find(mask,1);

fp_id = p_id(mask);
fp_sid = p_sid(mask);
fp_time = p_time(mask);

fps_data.p_x = ps_data.p_x(mask);
fps_data.p_y = ps_data.p_y(mask);
fps_data.p_z = ps_data.p_z(mask);

fps_data.p_npx = ps_data.p_npx(mask);
fps_data.p_npy = ps_data.p_npy(mask);
fps_data.p_npz = ps_data.p_npz(mask);

end