# Dynamic of the particle system

## Pure harmonic forces
Here we explore the dynamics of the particle system. For this system with $N$ masses equal to ${m}$ and coordinates ${\mathbf{r}_i}$, we will suppose that particles are bounded with springs with constant $k$ and zero rest position for the harmonic forces. This lead to the following coupled system of differential equations:

$
m \ddot{\mathbf{r}}_i = -k (2\mathbf{r}_i-\mathbf{r}_{i-1} -\mathbf{r}_{i+1} ),
$

with cyclic conditions.

In this approach we solve numerically the above equations using the Runge-Kutta 4th order method.


If we consider a circular initial state at rest, and we let evolve system, we have that evolution will be completely isotropically towards the center. Moreover the particles crosses the center oscillating periodically.

In the following Figures, in the first row we show this behavior for $N=500$ particles starting at rest with initial $r_i = 1$. All the springs constants are equal ($k = 1$)

Particles at four instants  |  Mean value of r as function of time | Mean value of velocity as function of time
:-------------------------:|:-------------------------:|:------:|
![](image.png)  |  ![](image-1.png) | ![](image-2.png)
![](image-3.png)|![](image-4.png) |![](image-5.png)

In the second and third row we have added some randomness to the initial position distribution (uniformed distributed between 0 and 0.05 for each component of $\mathbf{r}_i$)
