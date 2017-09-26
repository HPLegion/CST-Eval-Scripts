function cstPlot(filename)
%%Read File
[p_id, p_time, p_pos, p_nmom] =...
    importCstTrajectories(filename);

%% Determine Design Trajectory from particle 0
[dtr_ind, dtr_time, dtr_pos, dtr_rot]=...
    findDesignTrajectory(0,p_id, p_time, p_pos, p_nmom);

%% transform coordinates into comoving system
[p_pos_tr, p_nmom_tr] =...
    transformCoordinates(p_pos, p_nmom, dtr_pos, dtr_rot);

phaseSpacePlotter(p_pos_tr, p_nmom_tr, dtr_pos, filename)

%[em_x,em_y] = emittance(p_pos_tr, p_nmom_tr)
