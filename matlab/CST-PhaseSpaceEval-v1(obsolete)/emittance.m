function [em_x,em_y] = emittance(p_pos_tr, p_nmom_tr)
n = size(p_pos_tr,1);
len = length(p_pos_tr{1});

pos = reshape(p_pos_tr,1,1,n);
nmom =reshape(p_nmom_tr,1,1,n);

shortest = 
