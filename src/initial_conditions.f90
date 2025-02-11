module initial_conditions
    use global
    use math
    use dynamics
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
                theta = dble(i-1) * angle
                r0_vec(i,1) = R0 * dcos(theta)
                r0_vec(i,2) = R0 * dsin(theta)
            end do
        end subroutine

        subroutine set_initial(is_noise, temp)
            implicit none
            logical :: is_noise
            integer :: i
            real(8) :: temp, disturb(n_particles, n_dim)
            call geometry()
            if (is_noise) then
                do i = 1, n_particles
                    call random_normal(disturb(i,1))
                    call random_normal(disturb(i,2))
                    v0_vec(i,:) = v0_vec(i,:) + temp * disturb(i,:)
                end do
            end if
            r_vec = r0_vec
            v_vec = v0_vec
            call get_r_cm()
            do i = 1, n_particles
                r_vec(i,:) = r_vec(i,:) -r_cm
                v_vec(i,:) = v_vec(i,:) -v_cm
            end do
            r0_vec = r_vec
            v0_vec = v_vec
        end subroutine

end module initial_conditions