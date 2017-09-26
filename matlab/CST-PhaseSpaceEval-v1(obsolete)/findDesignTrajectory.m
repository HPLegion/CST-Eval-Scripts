function [dtr_ind, dtr_time, dtr_pos, dtr_rot]=findDesignTrajectory(dtr_id, p_id, p_time, p_pos, p_nmom)
%% Identify Design Trajectory
%dtr_id = 0; %CST ID of particle following design trajectory
dtr_ind = find([p_id{:}] == dtr_id); % Find Cell Index of that particle
%clear dtr_id

%% Load position and timestep
dtr_pos = p_pos{dtr_ind};
dtr_time = p_time{dtr_ind};
dtr_nmom = p_nmom{dtr_ind};
dtr_length = length(dtr_time);

%% Determine comoving (u,v,w) system from momentum
dtr_u = zeros(dtr_length,3);
dtr_v = zeros(dtr_length,3);
dtr_w = zeros(dtr_length,3);
dtr_rot = cell(dtr_length,1);

for k = 1:dtr_length
    p_norm_k = norm(dtr_nmom(k,:)); % Calculate norm of momentum
    
    if p_norm_k>0 %if momentum >0 use this to calculate u,v,w
        %Calculate w
        w_k = dtr_nmom(k,:); % w shows in direction of momentum 
        w_k = w_k/norm(w_k); % Normalise w
        
        %Calculate u
        u_k = w_k; %start at w
        u_k = u_k*[0,0,-1;0,1,0;1,0,0]; %rotate about y axis by -90deg
        u_k(2) = 0; %project onto x,z plane
        u_k = u_k/norm(u_k);% Normalise u
        
        %Calculate v
        v_k = cross(w_k,u_k); % v is cross product of w and u
    else %otherwise use x,y,z
        u_k = [1, 0, 0];
        v_k = [0, 1, 0];
        w_k = [0, 0, 1];
    end
    
    %Save in list
    dtr_u(k,:) = u_k;
    dtr_v(k,:) = v_k;
    dtr_w(k,:) = w_k;
    
    % Compose Rotation Matrices for x,y,z to u,v,w
    dtr_rot{k} = inv([u_k;v_k;w_k]);
end
clear k
clear u_k v_k w_k

%clear dtr_time dtr_nmom %Don't seem to need them at the moment


