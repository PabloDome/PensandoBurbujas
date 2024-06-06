# Geometría del problema

Supongamos que tenemos masas en los vértices de un polígono regular de $n$ lados. El polígono se encuentra centrado en un origen de coordenadas, y queremos determinar los ángulos interiores, y las posiciones de los vértices.

La suma de los ángulos internos de un polígono en radianes es $\sum_{i=1}^{n}{\alpha_i} = n\alpha = \pi(n-2)$, donde $\alpha_i$ son los ángulos interiores de cada vértice y son iguales a $\alpha$ dada la regularidad del polígono.

Dado $n$, y la posición de una de las partículas como fija, no hay más grados de libertad, por lo que todo el sistema queda fijo en el plano. En este caso pondremos una partícula sobre el eje x.

## Convenciones de notaciones y coordenadas

Llamaremos al sistema con origen en centro geométrico del polígono como $\mathbf{R}$ cuyas componentes estarán dadas por $(X,Y)$ en coordenadas cartesianas o $(R,\Theta)$ en coordenadas polares. Luego, situaremos sobre cada vértice otro eje de coordenadas: $\mathbf{r}_i$. Este conjunto de coordenadas permitirá describir el movimiento de cada uno de los vértices.