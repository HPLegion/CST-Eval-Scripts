import import_particle_data as ipd
import os


data_path = os.path.dirname(os.path.realpath(__file__)) + "\\data\\"

sourceIDFile = data_path + "source_names.txt"
names = ipd.import_source_names(sourceIDFile)
print(names)

constantsFile = data_path + "particle_constants.txt"
particle_constants = ipd.import_particle_constants(constantsFile)
# print(particle_constants)
print(particle_constants.dtypes)
# print(particle_constants[0:1])


trajectoriesFile = data_path + "particle_trajectories.txt"
particle_trajectories = ipd.import_particle_trajectories(trajectoriesFile)
print(particle_trajectories[16].dtypes)
# print(particle_trajectories[0])