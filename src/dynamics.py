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

def get_accel_zero_rest_distance_drag(r, v, k_over_m, drag_over_m, pressure):
    '''
    this function calculate the forces for each particle
    considering constrains as springs. All springs are identical
    INPUTS: x,y: coordinates of particles
            k: spring constant
    '''
    # we put the last coordinates at the beginning and first at the end
    # cyclic conditions
    new_r = np.hstack([r[:,-1].reshape(2,-1),r,r[:,0].reshape(2,-1)])
    # normal vector
    normal = (2*r-new_r[:,:-2]-new_r[:,2:])
    normal_unitary = normal/np.sqrt(normal[0,:]**2+normal[1,:]**2)
    # Calculate the forces
    accel = -k_over_m*normal - drag_over_m * v + pressure * normal_unitary

    return accel


def kick_drift_kick_step(r, v, k, drag, pressure, dt):
    a_old  = get_accel_zero_rest_distance_drag(r, v, k, drag, pressure)
    v_half = v + a_old * dt/2
    r_new  = r + v_half * dt
    a_new  = get_accel_zero_rest_distance_drag(r_new, v_half, k, drag, pressure)
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

def evolve(r, v, k_m, drag_m, pressure, dt, steps, **history):
    print(history)
    if history['value'] == True:
        v_dist = np.sqrt(v[0,:]**2+v[1,:]**2)
        r_dist = np.sqrt(r[0,:]**2+r[1,:]**2)

        v_mod = np.array([[v_dist.mean(), v_dist.std()]])
        r_mod = np.array([[r_dist.mean(), r_dist.std()]])
        if history['particles'] != 0:
            particles = np.random.choice(np.arange(len(r[0,:])),size=history['particles'])
            traces = np.hstack([r[:,i] for i in particles])
        else:
            traces = []

    for i in range(steps):
        r, v = kick_drift_kick_step(r, v, k_m, drag_m, pressure, dt)
        
        if history['value'] ==  True:
            if i % history['every'] == 0: 
                v_dist = np.sqrt(v[0,:]**2+v[1,:]**2)
                r_dist = np.sqrt(r[0,:]**2+r[1,:]**2)
                v_mod = np.vstack([v_mod, np.array([v_dist.mean(), v_dist.std()])])
                r_mod = np.vstack([r_mod, np.array([r_dist.mean(), r_dist.std()])])

                if history['particles'] != 0:
                    traces = np.vstack([traces, np.hstack([r[:,i] for i in particles])])

    if history['value'] == True:
        return r, v, r_mod, v_mod, traces
    else:
        return r, v
    
def plot_mean_values(r_mod, v_mod):
    '''
    This function returns a fig with rmod and vmod
    You must provide (n_steps, 2) arrays for each magnitude
    '''
    fig, axs = plt.subplots(1,2, figsize=(12,6))
    fig.suptitle('Mean Values')
    data = np.stack([r_mod.reshape(1,-1,2)[0], v_mod], axis=0)
    labels = ['<r>','<v>']
    for i in range(2):
        mv = np.array(data[i,:,0])
        sv = np.array(data[i,:,1])
        axs[i].plot(mv, label=labels[i])
        axs[i].fill_between(np.arange(len(mv)),mv-sv,mv+sv, alpha = 0.25 )
        axs[i].legend()
    return fig

def plot_trajs(trajs):
    n_particles = trajs.shape[1]//2
    fig = plt.figure(figsize=(6,6))
    for i in range(n_particles):
        plt.plot(trajs[:, 2*i], trajs[:, 2*i+1])
    return fig

def plot_particles_and_forces(r,f):
    fig = plt.figure(figsize=(6,6))
    plt.scatter(r[0,:],r[1,:])
    plt.quiver(r[0,:],r[1,:],f[0,:],f[1,:])
    return fig

if __name__ == '__main__':
    from geometry import get_poligon
    x,y = get_poligon(n = 50, R0=1.)
    r = np.vstack([x,y])
    # r = perturb_distribution(r, 0.)
    v = np.zeros_like(r)
    drag = 0.05 
    k_spring = 0.15 
    pressure= 0.01
    k_m = k_spring
    a = get_accel_zero_rest_distance_drag(r, v, k_m , drag, pressure)
    figura = plot_particles_and_forces(r,a)
    plt.show()


    history_conf = {'value':True, 'particles': 3, 'every':100}
    ev = evolve(r, v, k_m = k_m, 
                    drag_m= drag, 
                    pressure = pressure, 
                    dt = 0.001,
                    steps = 50000,
                    **history_conf
                   )

    figura = plot_mean_values(ev[2], ev[3])
    plt.show()
    print(r.shape, v.shape, ev[0].shape, ev[1].shape)
    a = get_accel_zero_rest_distance_drag(ev[0], ev[1], k_m, drag, pressure)
    figura = plot_particles_and_forces(ev[0],a)

    figura = plot_trajs(ev[4])
    plt.show()


