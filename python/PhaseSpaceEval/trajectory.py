"""
Contains a class that regulates the access to trajectory information
"""

import numpy as np

class Trajectory:
    """
    A class that regulates the access to trajectory information
    """
    def __init__(self, trajectory_frame, constants_frame):
        self.__trajectory_frame = trajectory_frame.copy()
        self.__constants_frame = constants_frame.copy()

        self.particleID  = self.__constants_frame.iloc[0, 0]
        self.mass = self.__constants_frame.loc[self.particleID, "mass"]
        self.macroCharge = self.__constants_frame.loc[self.particleID, "macroCharge"]
        self.sourceID = self.__constants_frame.loc[self.particleID, "sourceID"]

        self.time = self.__trajectory_frame["time"]