import numpy as np
import matplotlib.pyplot as plt


def get_forces_zero_rest_distance(x, y, k):
    '''
    this function calculate the forces for each particle
    considering constrains as springs. All springs are identical
    INPUTS: x,y: coordinates of particles
            k: spring constant
    '''
    # we put the last coordinates at the beginning and first at the end
    # cyclic conditions
    new_x = np.insert(x,0,x[-1])
    new_x = np.append(new_x,x[0])
    new_y = np.insert(y,0,y[-1])
    new_y = np.append(new_y,y[0])

    # Calculate the forces
    n = len(x)
    forces_x = np.zeros(n)
    forces_y = np.zeros(n)
    
    forces_x = -k*(2*x-new_x[:-2]-new_x[2:])
    forces_y = -k*(2*y-new_y[:-2]-new_y[2:]) 


    return forces_x, forces_y

if __name__ == '__main__':
    from geometry import get_poligon
    x,y = get_poligon()
    fx, fy = get_forces_zero_rest_distance(x,y,0.1)
    plt.scatter(x,y)
    plt.quiver(x,y,fx,fy)
    plt.show()