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

def kick_drift_kick_step(r, v, k, dt):
    a_old  = get_accel_zero_rest_distance(r, k)
    v_half = v + a_old * dt/2
    r_new  = r + v_half * dt
    a_new  = get_accel_zero_rest_distance(r_new, k)
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

if __name__ == '__main__':
    from geometry import get_poligon
    import matplotlib.animation as animation
    x,y = get_poligon(n = 120, R0=1.)
    r = np.vstack([x,y])
    r = perturb_distribution(r, 0.05)
    x,y = r[0,:], r[1,:]
    a = get_accel_zero_rest_distance(r, 0.1)
    plot_particles_and_forces(r,a)
    v = np.zeros_like(r)
    plt.figure(figsize=(6,6))
    plt.title('time evolution')

    v_dist = np.sqrt(v[0,:]**2+v[1,:]**2)
    r_dist = np.sqrt(r[0,:]**2+r[1,:]**2)

    v_mod = [[v_dist.mean(), v_dist.std()]]
    r_mod = [[r_dist.mean(), r_dist.std()]]
    
    single_particle = np.hstack([r[:,0], r[:,30]])
    for i in range(3000):
        r, v = kick_drift_kick_step(r,v,0.1,0.1)
        v_dist = np.sqrt(v[0,:]**2+v[1,:]**2)
        r_dist = np.sqrt(r[0,:]**2+r[1,:]**2)
        single_particle = np.vstack([single_particle, np.hstack([r[:,0], r[:,30]])])

        v_mod.append([v_dist.mean(), v_dist.std()])
        r_mod.append([r_dist.mean(), r_dist.std()])
        if i%200 == 0:
            plt.scatter(r[0,:], r[1,:], label=f'timestep: {i}')
            plt.quiver(r[0,:], r[1,:],v[0,:], v[1,:])
    plt.legend()
    plt.show()

    fig, axs = plt.subplots(1,2, figsize=(12,6))
    fig.suptitle('Mean Values')
    mv = np.array([e[0] for e in r_mod])
    sv = np.array([e[1] for e in r_mod])
    axs[0].plot([e[0] for e in r_mod], label='<r>')
    axs[0].fill_between(np.arange(mv.shape[0]),mv-sv,mv+sv, alpha = 0.25 )
    axs[0].legend()
    mv = np.array([e[0] for e in v_mod])
    sv = np.array([e[1] for e in v_mod])
    axs[1].plot([e[0] for e in v_mod], label='<v>')
    axs[1].fill_between(np.arange(mv.shape[0]),mv-sv,mv+sv, alpha = 0.25 )
    axs[1].legend()
    plt.show()

    plt.figure(figsize=(6,6))
    plt.xlim(-1.25, 1.25)
    plt.ylim(-1.25,1.25)
    plt.scatter(x[0], y[0])
    plt.scatter(x[30], y[30])
    plt.plot(single_particle[:,0], single_particle[:,1], label = 'particle 0')
    plt.plot(single_particle[:,2], single_particle[:,3], label = 'particle 30')
    plt.show()