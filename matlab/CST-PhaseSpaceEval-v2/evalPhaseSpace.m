function [ts_coordinates,n_lost] = evalPhaseSpace(T0, time_lim, ps_splines, dtr_ind)
%%Setup
n = length(ps_splines.p_x_s);

ts_x = zeros(n,1);
ts_y = zeros(n,1);
ts_l = zeros(n,1);
ts_xprime = zeros(n,1);
ts_yprime = zeros(n,1);
ts_delta = zeros(n,1);

%% Determine Design Values (normalised)
[dtr_p0,dtr_v0] = findDesignMomentum(T0,dtr_ind,ps_splines,time_lim);
dtr_pos = [ppval(ps_splines.p_x_s{dtr_ind},T0),...
    ppval(ps_splines.p_y_s{dtr_ind},T0),...
    ppval(ps_splines.p_z_s{dtr_ind},T0)];

%% Find Evaluation Plane
[u,v,w,dtr_rot] = findUVW(ps_splines,dtr_ind,time_lim,T0);


%% Evaluate all particles
parfor k = 1:n
    if (time_lim.p_time_min{k}<=T0 && T0<=time_lim.p_time_max{k})
        %Load relevant splines
        spl_x = ps_splines.p_x_s{k};
        spl_y = ps_splines.p_y_s{k};
        spl_z = ps_splines.p_z_s{k};
        
        %Compute Time of Intersection with Eval Plane and position in it
        [T_cross,xdev,ydev] = findIntersectionTime(u, v,w, dtr_pos, spl_x, spl_y, spl_z, T0, time_lim);
        ts_x(k) = xdev;
        ts_y(k) = ydev;
        
        %Calculate longitudinal displacement
        ts_l(k) = -dtr_v0*(T_cross-T0);
        
        %Rotate momentum vector into comoving coordinate system
        np = [ppval(ps_splines.p_npx_s{k}, T0),...
            ppval(ps_splines.p_npy_s{k}, T0),...
            ppval(ps_splines.p_npz_s{k}, T0)];
        np_tr = np*dtr_rot;
        
        % Compute transverse deflection and momentum spread
        ts_xprime(k) = 1000*atan(np_tr(1)/np_tr(3));
        ts_yprime(k) = 1000*atan(np_tr(2)/np_tr(3));
        ts_delta(k) = (norm(np_tr)-dtr_p0)/dtr_p0;
    else %if particle already crashed
        ts_x(k) = NaN;
        ts_y(k) = NaN;
        ts_l(k) = NaN;
        
        ts_xprime(k) = NaN;
        ts_yprime(k) = NaN;
        ts_delta(k) = NaN;
    end
end

%%Pack up results
n_lost = sum(isnan(ts_x)); %Number of crashed/lost particles
ts_coordinates = struct('x', ts_x, 'y' ,ts_y, 'l', ts_l,...
    'xprime', ts_xprime, 'yprime' ,ts_yprime, 'delta', ts_delta);
end

function [u,v,w,dtr_rot] = findUVW(ps_splines,dtr_ind,time_lim,T0)

[dtr_p0,~] = findDesignMomentum(T0,dtr_ind,ps_splines,time_lim);
if dtr_p0>0 %if momentum >0 use this to calculate u,v,w
    %Calculate w
    w = [ppval(ps_splines.p_npx_s{dtr_ind},T0),...
        ppval(ps_splines.p_npy_s{dtr_ind},T0),...
        ppval(ps_splines.p_npz_s{dtr_ind},T0)]; % w shows in direction of momentum
    w = w/norm(w); % Normalise w
    
    %Calculate u
    u = w; %start at w
    u = u*[0,0,-1;0,1,0;1,0,0]; %rotate about y axis by +90deg
    u(2) = 0; %project onto x,z plane
    u = u/norm(u);% Normalise u
    
    %Calculate v
    v = cross(w,u); % v is cross product of w and u
else %otherwise use x,y,z
    u = [1, 0, 0];
    v = [0, 1, 0];
    w = [0, 0, 1];
end

% Compose Rotation Matrices for x,y,z to u,v,w
dtr_rot = inv([u;v;w]);

end

function [dtr_p0,dtr_v0] = findDesignMomentum(T0,dtr_ind,ps_splines,time_lim)
if (time_lim.dtr_time_min <= T0) && (T0 <= time_lim.dtr_time_max)
    dtr_p0 = sqrt(...
        ppval(ps_splines.p_npx_s{dtr_ind}, T0)^2+...
        ppval(ps_splines.p_npy_s{dtr_ind}, T0)^2+...
        ppval(ps_splines.p_npz_s{dtr_ind}, T0)^2);
    dtr_v0 = dtr_p0*299792458*1000/10^9 / sqrt(1 + norm(dtr_p0)^2); %Fully relativistic 
else
    error('not a valid value for T0, design trajectory not defined')
    
end
end

function [T,u_out,v_out] = findIntersectionTime(u, v, w, dtr_pos, spl_x, spl_y, spl_z, T0, time_lim)
% ops = optimoptions('fsolve','Display', 'off');
% sol = fsolve(@fnc,[T0,0,0],ops);
% T = sol(1); aout = sol(2); bout = sol(3);
%
%     function res = fnc(x)
%         t = x(1);
%         a = x(2);
%         b = x(3);
%         prtcl = [ppval(spl_x,t), ppval(spl_y,t), ppval(spl_z,t)];
%         res = dtr_pos + a*u+b*v -prtcl;
%     end

ops = optimoptions('fsolve','Display', 'off');
T = fsolve(@fnc,T0,ops);
prtcl_pos_T = [ppval(spl_x,T), ppval(spl_y,T), ppval(spl_z,T)];
u_out = (prtcl_pos_T-dtr_pos)*u';
v_out = (prtcl_pos_T-dtr_pos)*v';
    function res = fnc(t)
        prtcl_pos = [ppval(spl_x,t), ppval(spl_y,t), ppval(spl_z,t)];
        res = (prtcl_pos-dtr_pos)*w';
    end

end