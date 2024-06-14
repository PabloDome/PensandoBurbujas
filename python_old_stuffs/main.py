import numpy as np

from geometry import get_poligon
from dynamics import *

x,y = get_poligon(n = 12, R0=1.)
r = np.vstack([x,y])
r = perturb_distribution(r, 0.05)
v = np.zeros_like(r)
a = get_accel_zero_rest_distance_drag_0(r, v, 0.1, 0.01)
plot_particles_and_forces(r,a)
history_conf = {'value':True, 'particles': 3}
ev = evolve(r, v, k_m= 0.1, drag_m= 0.01, dt = 0.1,
                steps=3000,
                **history_conf
                )
print(ev)