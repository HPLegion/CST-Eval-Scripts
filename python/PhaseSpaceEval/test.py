import import_particle_data as ipd
import os
import pandas as pd
from trajectory import Trajectory
import numpy as np
from scipy import interpolate
from particlemonitor import ParticleMonitor

data_path = os.path.dirname(os.path.realpath(__file__)) + "\\data\\"

# sourceIDFile = data_path + "source_names.txt"
# names = ipd.import_source_names(sourceIDFile)
# print(names)

constantsFile = data_path + "particle_constants.txt"
particle_constants = ipd.import_particle_constants(constantsFile)
# print(particle_constants)
# print(particle_constants.dtypes)
# print(particle_constants.index.dtype)
# print(particle_constants.loc[0,"mass"])
# print(type(particle_constants.loc[0,"mass"]))

# temp = particle_constants.loc[[0]]
# print(temp)



trajectoriesFile = data_path + "particle_trajectories.txt"
particle_trajectories = ipd.import_particle_trajectories(trajectoriesFile)
# print(particle_trajectories[16].dtypes)
# print(particle_trajectories[0])

tr = Trajectory(particle_trajectories[0],particle_constants.loc[[0]])

print(tr.interp_pos(10))
print(tr.interp_abs_vel(10))
print(tr.tmin, tr.tmax)

pm = ParticleMonitor(300, trajectory=tr)
print()