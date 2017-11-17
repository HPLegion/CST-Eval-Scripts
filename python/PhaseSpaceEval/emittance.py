"""
function calculating the emittance
"""

import numpy as np

def emittance(x, xp):
    """
    returns the emittance of x and xp
    both input vectors have to be numpy arrays (1D) of the same length
    """
    return np.sqrt(np.linalg.det(np.cov(x, xp)))
