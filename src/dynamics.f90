module dynamics
    use global
    implicit none

    
contains
    subroutine calculate_accel()
        implicit none
        integer :: i
        real(8), dimension(:,:), allocatable :: new_r, r_versor, r_vector

        allocate(new_r(0:n_particles+1, n_dim))
        allocate(r_versor(n_particles,n_dim))
        allocate(r_vector(n_particles,n_dim))
        ! Cyclic condition for particles
        new_r(1:n_particles,:) = r_vec
        new_r(0,:) = r_vec(n_particles,:)
        new_r(n_particles+1,:) = r_vec(1,:) 

        r_vector = (2*r_vec-new_r(0:n_particles-1,:)-new_r(2:n_particles+1,:))
        do i = 1, n_particles
            r_versor(i,:) = r_vector(i,:)/dsqrt(dot_product(r_vector(i,:),r_vector(i,:)))
        end do

        a_vec = -k_m*r_vector
        a_vec = a_vec - drag_m * v_vec
        a_vec = a_vec + pressure*r_versor
        deallocate(new_r)
        deallocate(r_versor)
    end subroutine

    subroutine evolve_one_step(dt, method)
        implicit none
        real(8) :: dt, q_vec(n_particles, 2*n_dim), y_out(n_particles, 2*n_dim)
        integer :: method
        if ( method == 0 ) then     !verlet algorithm
            call calculate_accel()
            v_vec = v_vec + a_vec * dt/2
            r_vec  = r_vec + v_vec * dt
            call calculate_accel()
            v_vec  = v_vec + a_vec * dt/2
        elseif (method == 1) then
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