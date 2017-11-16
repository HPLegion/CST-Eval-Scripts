"""
Contains a class that represents a particle monitor
"""
import numpy as np
from scipy import interpolate

class ParticleMonitor:
    """
    A class that represents a particle monitor
    """

    def __init__(self, time0, trajectory=None,
                 r0=np.array([0, 0, 0]), u=np.array([0, 0, 0]),
                 v=np.array([0, 0, 0]), w=np.array([0, 0, 0]), abs_vel=0):
        """
        Initialiser for the ParticleMonitor Object
        can either manually define the required parameters or hand over a trajectory from which they will be computed
        A time is always required!

        Keyword Args:
        time0 -- Arrival time of the design trajectory
        trajectory -- Default=None
        r0 -- [x,y,z] array of the design position
        u,v,w -- Local coordinate system, each a [x,z,y] array
        vel -- the absolute velocity of the design trajectory
        """

        self.time0 = time0

        # If no trajectory is given use defaults or manual user input
        if trajectory == None:
            self.r0 = r0.copy()
            self.u = u.copy()
            self.v = v.copy()
            self.w = w.copy()
            self.vel = abs_vel
        # Else compute r0, u,v,w and abs_vel from trajectory
        else:
            assert trajectory.tmin <= time0 <= trajectory.tmax, "Time out of bounds"
            self.r0 = trajectory.interp_pos(self.time0)
            self.vel = trajectory.interp_abs_vel(self.time0)
            self.__compute_uvw(trajectory)
        # Compose Rotation Matrix for x,y,z to u,v,w
        self.rotmat = np.linalg.inv(np.array([self.u, self.v, self.w]))


    def __compute_uvw(self, trajectory):
        # w shows in momentum direction
        w = trajectory.interp_mom(self.time0)
        w /= np.linalg.norm(w)

        # Calculate u
        u = w.copy() # start at w
        yrotmat = np.array([[0, 0, -1], [0, 1, 0], [1, 0, 0]]) # rotate about y axis by 90deg
        u = u.dot(yrotmat)
        u[1] = 0 # project onto x,z plane
        u /= np.linalg.norm(u) # Normalise u

        # Calculate v
        v = np.cross(w,u) # v is cross product of w and u
        self.u = u
        self.v = v
        self.w = w
