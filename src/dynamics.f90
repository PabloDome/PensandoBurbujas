module dynamics
    use global
    use disorder

    implicit none

    
contains
    subroutine get_r_cm()
        implicit none
        r_cm(1) = sum(r_vec(:,1))/n_particles
        r_cm(2) = sum(r_vec(:,2))/n_particles
        v_cm(1) = sum(v_vec(:,1))/n_particles
        v_cm(2) = sum(v_vec(:,2))/n_particles
    end subroutine

    subroutine calculate_accel()
        implicit none
        integer :: i
        real(8), dimension(:,:), allocatable :: new_r, r_versor, r_vector, disforce, new_r_versor
        real(8), dimension(:), allocatable :: new_r_mod, kernel

        allocate(new_r(0:n_particles+1, n_dim))
        allocate(new_r_mod(n_particles))     ! distancia entre particulas (auxiliar)
        allocate(new_r_versor(n_particles, n_dim))  ! direccion entre partículas (auxiliar)
        allocate(r_versor(n_particles,n_dim))  ! versor de la particula iesima respecto del CM
        allocate(r_vector(n_particles,n_dim))   ! vector relativo entre las particulas (i, i+1) o (i, i-1)
        allocate(disforce(n_particles,n_dim))
        allocate(kernel(n_particles))
        ! Cyclic condition for particles 
        new_r(1:n_particles,:) = r_vec
        new_r(0,:) = r_vec(n_particles,:)
        new_r(n_particles+1,:) = r_vec(1,:) 
        a_vec = 0d0
        !***********************************************************************************
        ! Pseudo / Elastic acceleration calculation
        !***********************************************************************************
        ! ! vector (extension) for the elastic force (rest position in zero for relative coordinates)
        ! ! This is useful for elastic forces where F_ij = r_ij r_ij(versor) where j = {i-1, i+1}
        ! r_vector = (2d0*r_vec-new_r(0:n_particles-1,:)-new_r(2:n_particles+1,:))
        r_vector = new_r(1:n_particles, : )-new_r(0:n_particles-1,:) ! r_(i,i-1) vector
        new_r_mod = dsqrt(sum(r_vector**2, 2))
        kernel = grad_potential(new_r_mod)
        do i =1, n_dim
            new_r_versor(:,i) = r_vector(1:n_particles,i)/new_r_mod(:)
            a_vec(:,i) = - kernel * new_r_versor(:,i)
        end do
        r_vector = new_r(2:n_particles+1, : )-new_r(1:n_particles,:) ! r_(i,i-1) vector
        new_r_mod = dsqrt(sum(r_vector**2, 2))
        kernel = grad_potential(new_r_mod)
        do i =1, n_dim
            new_r_versor(:,i) = r_vector(1:n_particles,i)/new_r_mod(:)
            a_vec(:,i) = a_vec(:,i) - kernel * new_r_versor(:,i)
        end do
        !***********************************************************************************

        !direction of each particle from the center of mass
        call get_r_cm()
        do i =1, n_particles
            r_versor(i,:) = r_vec(i,:) - r_cm
            r_versor(i,:)= r_versor(i,:)/dsqrt(dot_product(r_versor(i,:),r_versor(i,:))+1d-20)
        end do


        ! do i = 1, n_particles
        !     r_versor(i,:) = r_vector(i,:)/dsqrt(dot_product(r_vector(i,:),r_vector(i,:))+1d-20)
        ! end do

        ! ! static dirorder
        ! do i = 1, n_particles
        !     r_versor(i,:) = r_vec(i,:)/dsqrt(dot_product(r_vec(i,:),r_vec(i,:))+1d-20)
        !     call disorder_force(r_vec(i,:),disforce(i,:))
        ! end do

        ! call random_forces(disforce)

        a_vec = a_vec - drag_m * v_vec
        ! pressure is applied in the center of mass direction
        a_vec = a_vec + pressure*r_versor
        ! a_vec = a_vec + disforce
        

        deallocate(new_r_mod)     ! distancia entre particulas (auxiliar)
        deallocate(new_r_versor)  ! direccion entre partículas (auxiliar)
        deallocate(r_vector)   ! vector relativo entre las particulas (i, i+1) o (i, i-1)
        deallocate(new_r)
        deallocate(r_versor)
        deallocate(disforce)
        deallocate(kernel)
    end subroutine

    REAL(8) ELEMENTAL FUNCTION grad_potential(R)
        REAL(8), INTENT(IN) :: R  
        grad_potential = 2d0* k_m/cut_dist * dtanh(R/cut_dist) * (1d0/dcosh(R/cut_dist)**2)
    END FUNCTION grad_potential

    subroutine evolve_one_step(dt, method)
        implicit none
        real(8) :: dt, q_vec(n_particles, 2*n_dim), y_out(n_particles, 2*n_dim)
        integer :: method
        if ( method == 0 ) then     !verlet algorithm
            call calculate_accel()
            v_vec = v_vec + a_vec * dt/2d0
            r_vec  = r_vec + v_vec * dt
            call calculate_accel()
            v_vec  = v_vec + a_vec * dt/2d0
        elseif (method == 1) then   ! rk4 algorithm
            q_vec(:,1:n_dim) = r_vec
            q_vec(:, n_dim+1:2*n_dim) = v_vec
            call rk4(q_vec, 0d0, dt, y_out)
            r_vec = y_out(:,1:n_dim)
            v_vec = y_out(:,n_dim+1:2*n_dim)
        end if

    end subroutine

    subroutine derivs(x, y, dydx)
        implicit none
        real(8), intent(in) :: x
        real(8), intent(out) :: y(n_particles,2*n_dim), dydx(n_particles,2*n_dim)

        dydx(:,1:n_dim) = y(:,n_dim+1:2*n_dim)
        r_vec = y(:,1:n_dim)
        v_vec = y(:,n_dim+1:2*n_dim)
        call calculate_accel()
        dydx(:,n_dim+1:2*n_dim) = a_vec
    end subroutine

    subroutine rk4(y,x,h,yout)
        implicit none
        real(8) :: h, x, dydx(n_particles,2*n_dim), y(n_particles,2*n_dim), yOut(n_particles,2*n_dim)
        real(8) :: h6, hh, xh, dym(n_particles,2*n_dim), dyt(n_particles,2*n_dim), yt(n_particles,2*n_dim)
        hh=h*0.5d0
        h6=h/6d0
        xh=x+hh
        
        call derivs(x,y,dydx)
        yt = y + hh * dydx
    
        call derivs(xh,yt,dyt)
        yt = y + hh * dyt
    
        call derivs(xh,yt,dym)
        yt = y + h * dym
        dym = dyt + dym
        
        call derivs(x+h,yt,dyt)
        yOut = y + h6 * (dydx + dyt + 2d0 * dym)
    
    end subroutine
end module dynamics