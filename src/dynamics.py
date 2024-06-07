import numpy as np
import matplotlib.pyplot as plt

def plot_particles_and_forces(r,f):
    plt.figure(figsize=(6,6))
    plt.scatter(r[0,:],r[1,:])
    plt.quiver(r[0,:],r[1,:],f[0,:],f[1,:])
    plt.show()

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

def get_accel_zero_rest_distance_drag_0(r, v, k_over_m, drag_over_m):
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
    accel = accel - drag_over_m * v

    return accel

def kick_drift_kick_step(r, v, k, drag, dt):
    a_old  = get_accel_zero_rest_distance_drag_0(r, v, k, drag)
    v_half = v + a_old * dt/2
    r_new  = r + v_half * dt
    a_new  = get_accel_zero_rest_distance_drag_0(r_new, v_half, k, drag)
    v_new  = v_half + a_new * dt/2
    return r_new, v_new

def perturb_distribution(x, std):
    '''
    This method performs a simple random perturbation of particles distribution
    x: numpy array (either r or v)
    *args: (mean, std) for normal distribution
    '''
    rng = np.random.default_rng()
    x = rng.normal(x, std)
    return x 

def evolve(r, v, k_m, drag_m, dt, steps, **history):
    print(history)
    if history['value'] == True:
        v_dist = np.sqrt(v[0,:]**2+v[1,:]**2)
        r_dist = np.sqrt(r[0,:]**2+r[1,:]**2)

        v_mod = [[v_dist.mean(), v_dist.std()]]
        r_mod = [[r_dist.mean(), r_dist.std()]]
        if history['particles'] != 0:
            particles = np.random.choice(np.arange(len(r[0,:])),size=history['particles'])
            traces = np.hstack([r[:,i] for i in particles])
        else:
            traces = []

    for i in range(steps):
        r, v = kick_drift_kick_step(r, v, k_m, drag_m, dt)
        
        if history['value'] ==  True:
            v_dist = np.sqrt(v[0,:]**2+v[1,:]**2)
            r_dist = np.sqrt(r[0,:]**2+r[1,:]**2)
            v_mod.append([v_dist.mean(), v_dist.std()])
            r_mod.append([r_dist.mean(), r_dist.std()])

            if history['particles'] != 0:
                traces = np.vstack([traces, np.hstack([r[:,i] for i in particles])])

    if history['value'] == True:
        return r, v, r_mod, v_mod, traces
    else:
        return r, v
    

if __name__ == '__main__':
    from geometry import get_poligon
    x,y = get_poligon(n = 12, R0=1.)
    r = np.vstack([x,y])
    r = perturb_distribution(r, 0.05)
    x,y = r[0,:], r[1,:]
    v = np.zeros_like(r)
    a = get_accel_zero_rest_distance_drag_0(r, v, 0.1, 0.01)
    plot_particles_and_forces(r,a)
    history_conf = {'value':True, 'particles': 3}
    ev = evolve(r, v, k_m= 0.1, drag_m= 0.01, dt = 0.1,
                   steps=3000,
                   **history_conf
                   )
    print(ev)