import numpy as np
import matplotlib.pyplot as plt


def get_accel_zero_rest_distance(r, k_over_m):
    '''
    this function calculate the forces for each particle
    considering constrains as springs. All springs are identical
    INPUTS: x,y: coordinates of particles
            k: spring constant
    '''
    # we put the last coordinates at the beginning and first at the end
    # cyclic conditions
    new_r = np.hstack([r[:,-1].reshape(2,-1),r,r[:,0].reshape(2,-1)])
    # Calculate the forces
    accel = -k_over_m*(2*r-new_r[:,:-2]-new_r[:,2:])
    return accel

def plot_particles_and_forces(r,f):
    plt.figure(figsize=(6,6))
    plt.scatter(r[0,:],r[1,:])
    plt.quiver(r[0,:],r[1,:],f[0,:],f[1,:])
    plt.show()

def kick_drift_kick_step(r, v, k, dt):
    a_old  = get_accel_zero_rest_distance(r, k)
    v_half = v + a_old * dt/2
    r_new  = r + v_half * dt
    a_new  = get_accel_zero_rest_distance(r, k)
    v_new  = v_half + a_new * dt/2
    return r_new, v_new

if __name__ == '__main__':
    from geometry import get_poligon
    import matplotlib.animation as animation
    x,y = get_poligon(n = 120, R0=1.)
    r = np.vstack([x,y])
    a = get_accel_zero_rest_distance(r, 0.1)
    plot_particles_and_forces(r,a)
    v = np.zeros_like(r)
    plt.figure(figsize=(6,6))
    plt.title('time evolution')
    r_med = []
    v_med = []
    for i in range(1000):
        r, v = kick_drift_kick_step(r,v,0.1,0.1)
        v_med.append(np.sqrt(np.apply_along_axis(lambda x: x**2,0, v)).mean())
        r_med.append(np.sqrt(np.apply_along_axis(lambda x: x**2,0, r)).mean())
        if i%200 == 0:
            plt.scatter(r[0,:], r[1,:], label=f'timestep: {i}')
            plt.quiver(r[0,:], r[1,:],v[0,:], v[1,:])
    plt.legend()
    plt.show()
    plt.figure(figsize=(6,6))
    plt.title('Mean Values')
    plt.plot(r_med, label='<r>')
    plt.plot(v_med, label='<v>')
    plt.legend()
    plt.show()