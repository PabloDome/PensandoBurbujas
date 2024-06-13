module dynamics
    use global
    implicit none

    
contains
    subroutine calculate_accel(k_m, drag_m, pressure)
        implicit none
        integer :: i
        real(8) :: k_m, drag_m, pressure
        real(8), dimension(:,:), allocatable :: new_r, r_versor

        allocate(new_r(0:n_particles+1, n_dim))
        allocate(r_versor(n_particles,n_dim))
        ! Cyclic condition for particles
        new_r(1:n_particles,:) = r_vec
        new_r(0,:) = r_vec(n_particles,:)
        new_r(n_particles+1,:) = r_vec(1,:) 

        do i = 1, n_particles
            r_versor(i,:) = r_vec(i,:)/ dsqrt(r_vec(i,1)**2 + r_vec(i,2)**2)
        end do

        a_vec = -k_m*((2*r_vec-new_r(0:n_particles-1,:)-new_r(2:n_particles+1,:)))
        a_vec = a_vec - drag_m * v_vec
        a_vec = a_vec + pressure*r_versor

        deallocate(new_r)
    end subroutine

    subroutine evolve_one_step(dt, k_m, drag_m, pressure, method)
        implicit none
        real(8) :: dt, k_m, drag_m, pressure
        integer :: method

        if ( method == 0 ) then
            call calculate_accel(k_m, drag_m, pressure)
            v_vec = v_vec + a_vec * dt/2
            r_vec  = r_vec + v_vec * dt
            call calculate_accel(k_m, drag_m, pressure)
            v_vec  = v_vec + a_vec * dt/2            
        end if

    end subroutine

end module dynamics