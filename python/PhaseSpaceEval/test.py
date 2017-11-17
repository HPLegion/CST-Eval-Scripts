import import_particle_data as i_p_d
import os
import pandas as pd
from trajectory import Trajectory
import numpy as np
from scipy import interpolate
from particlemonitor import ParticleMonitor
import cst_export_parser
from emittance import emittance
# data_path = os.path.dirname(os.path.realpath(__file__)) + "\\data\\"

# data3_path = os.path.dirname(os.path.realpath(__file__)) + "\\data3\\"
# testFile = data3_path + "step sample.txt"
# cst_export_parser.split_output_file(testFile, tmin=290, tmax=293)

print(emittance(np.array([1,0,-1]), np.array([-1,0,1])))
# # sourceIDFile = data_path + "source_names.txt"
# # names = i_p_d.import_source_names(sourceIDFile)
# # print(names)

# constantsFile = data_path + "particle_constants.txt"
# particle_constants = i_p_d.import_particle_constants(constantsFile)
# # print(particle_constants)
# # print(particle_constants.dtypes)
# # print(particle_constants.index.dtype)
# # print(particle_constants.loc[0,"mass"])
# # print(type(particle_constants.loc[0,"mass"]))

# # temp = particle_constants.loc[[0]]
# # print(temp)



# trajectoriesFile = data_path + "particle_trajectories.txt"
# particle_trajectories = i_p_d.import_particle_trajectories(trajectoriesFile)
# # print(particle_trajectories[16].dtypes)
# # print(particle_trajectories[0])

# tr = Trajectory(particle_trajectories[0],particle_constants.loc[[0]])
# tr2 = Trajectory(particle_trajectories[1],particle_constants.loc[[1]])

# print(tr.interp_pos(10))
# print(tr.interp_abs_vel(10))
# print(tr.tmin, tr.tmax)

# pm = ParticleMonitor(302, trajectory=tr)

# print(pm.record_intersect(tr))
# print(pm.record_intersect(tr2))
# print(pm.record_intersect(tr2))
# print(pm.record_intersect(tr2))
# print(pm.get_events())