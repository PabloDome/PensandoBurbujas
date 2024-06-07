# Dynamic of the particle system

Here we explore the dynamics of the particle system. For the particle system with masses ${m_i}$ and coordinates ${\mathbf{r}_i}$, we have the coupled system of differential equations:
$$
\begin{equation}
    m_i \ddot{\mathbf{r}}_i = -k \left(2\mathbf{r}_i-\mathbf{r}_{i-1} -\mathbf{r}_{i+1} \right),
\end{equation}
$$
with cyclic conditions.

To solve the former system, we will use numerical algorithms, particularly one of the so-called _Leap-frog_ schemes: the _kick-drift-kick_. This integration method propose the following scheme:

* The second-order $n$ equations are is splitted into $2n$ first-order differential equations
$$
\begin{align}
    \dot{\mathbf{v}}_i &= &\mathbf{a_i}, \\
    \dot{\mathbf{r}}_i &= &\mathbf{v_i},
\end{align}
$$

* Given the accelerations $\mathbf{a_i}=\mathbf{F_i}/m_i$, velocities $\mathbf{v_i}$ and positions $\mathbf{r}_i $ at the instant $t_i$, we can calculate the next step as follows:
$$
\begin{align}
v_{i+1/2} & = v_{i}+a_{i}{\frac {\Delta t}{2}},\\
x_{i+1}   & = x_{i}+v_{i+1/2}\Delta t,\\
v_{i+1}   & = v_{i+1/2}+a_{i+1}{\frac {\Delta t}{2}},
\end{align}
$$

## Dummy problem

If we consider a circular initial state at rest, an let evolve all the particles, we have that evolution will be completely isotropically towards the center.