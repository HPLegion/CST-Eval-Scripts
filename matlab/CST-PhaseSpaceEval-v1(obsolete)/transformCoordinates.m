function [p_pos_tr, p_nmom_tr] = transformCoordinates(p_pos, p_nmom, dtr_pos, dtr_rot)

p_pos_tr = p_pos;
p_nmom_tr = p_nmom;

n = size(p_pos,1);
dtr_length = size(dtr_pos,1);

%%Trim data to available design trajectory
for k = 1:n
    if length(p_pos_tr{k})>dtr_length
        p_pos_tr{k} = p_pos_tr{k}(1:dtr_length,:);
        p_nmom_tr{k} = p_nmom_tr{k}(1:dtr_length,:);
    end
end

for k = 1:n
    for j=1:min(dtr_length,length(p_pos_tr{k}))
        p_pos_tr{k}(j,:) = (p_pos_tr{k}(j,:)-dtr_pos(j,:))*dtr_rot{j};
        p_nmom_tr{k}(j,:) = p_nmom_tr{k}(j,:)*dtr_rot{j};
    end
end
clear j k 