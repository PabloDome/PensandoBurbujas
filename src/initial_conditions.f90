module initial_conditions
    use global
    use math
    implicit none
    real(8) :: R0
    
    contains
        subroutine geometry()
            integer :: i 
            real(8) :: alpha, angle, theta

            alpha = pi*dble(n_particles-2)/dble(n_particles)  ! The internal angle of each vertice
            angle = pi - alpha   !The minimum invariant rotation angle 
            r0_vec = 0d0
            do i = 1, n_particles
                theta = (i-1) * angle
                r0_vec(i,1) = R0 * dcos(theta)
                r0_vec(i,2) = R0 * dsin(theta)
            end do
        end subroutine

        subroutine set_initial(is_noise, factor)
            implicit none
            logical :: is_noise
            real(8) :: factor, disturb(n_particles, n_dim)
            call geometry()
            if (is_noise) then
                call random_number(disturb)
                r0_vec = r0_vec + factor * (disturb-0.5d0)
            end if
            v0_vec = 0d0
        end subroutine

end module initial_conditions