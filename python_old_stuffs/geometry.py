import numpy as np
import matplotlib.pyplot as plt


def get_poligon(n = 8, R0 = 1.0):
    alpha = np.pi*(n-2)/n   # The internal angle of each vertice
    angle = np.pi - alpha   # The minimum invariant rotation angle 
    x,y = np.zeros(n), np.zeros(n)
    for i in range(n):
        theta = i * angle
        x[i] = R0* np.cos(theta)
        y[i] = R0* np.sin(theta)
    return x,y

def plot_poligon(x,y):
    fig, ax = plt.subplots(1,1,figsize=(6,6))
    for i in range(x.shape[0]):
        ax.scatter(x[i], y[i])
    plt.show()



if __name__ == '__main__':

    x,y = get_poligon(n=32)
    plot_poligon(x,y)