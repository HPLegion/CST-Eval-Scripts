%function[p_time_min,p_time_max] = findTimeRanges(p_time, dtr_ind)
function time_lim = findTimeRanges(p_time, dtr_ind)

n = length(p_time);
p_time_min = cell(n,1);
p_time_max = cell(n,1);

parfor k = 1:n
    p_time_min{k} = p_time{k}(1);
    p_time_max{k} = p_time{k}(end);
end

dtr_time_min = p_time_min{dtr_ind};
dtr_time_max = p_time_max{dtr_ind};

time_lim = struct('p_time_min', {p_time_min}, 'p_time_max', {p_time_max},...
    'dtr_time_min', dtr_time_min, 'dtr_time_max', dtr_time_max);

end