module math
    use global
    use dynamics
    implicit none
    real(8), parameter :: pi = 3.14159265359d0

    contains
        subroutine get_mean_values(r_mean, r_std, v_mean, v_std, v_rad_mean, T_mean)
            ! This sub can calculate relevant mean values of the particle system
            implicit none
            integer :: i
            real(8) :: r_primed(n_particles,n_dim),r_versor(n_particles,n_dim), v_primed(n_particles,n_dim)
            real(8) :: r_mean, r_std, v_mean, v_std, T_mean, v_rad_mean, v_rad(n_particles)
            
            call get_r_cm()
            r_primed(:,1) = r_vec(:,1) - r_cm(1)
            r_primed(:,2) = r_vec(:,2) - r_cm(2)
            v_primed(:,1) = v_vec(:,1) - v_cm(1)
            v_primed(:,2) = v_vec(:,2) - v_cm(2)
            do i=1, n_particles
                r_versor(i,:) = r_primed(i,:)/dsqrt(sum(r_primed(i,:)**2))
            end do

            r_mean = sum(dsqrt(r_primed(:,1)**2d0+r_primed(:,2)**2d0))/dble(n_particles)
            r_std = dsqrt(sum( (dsqrt(r_primed(:,1)**2d0+r_primed(:,2)**2d0) - r_mean)**2)/dble(n_particles))
            v_mean = sum(dsqrt(v_primed(:,1)**2d0+v_primed(:,2)**2d0))/dble(n_particles)
            v_std = dsqrt(sum( (dsqrt(v_primed(:,1)**2d0+v_primed(:,2)**2d0) - v_mean)**2)/dble(n_particles))
            do i= 1, n_particles
                v_rad(i) = dot_product(r_versor(i,:), v_primed(i,:))
            end do
            v_rad_mean = sum(v_rad)/n_particles
            T_mean = 0.5d0*sum( v_primed(:,1)**2d0 + v_primed(:,2)**2d0 )/dble(n_particles)
        end subroutine

        subroutine boxmuller(n2)
            implicit none
            real(8) :: u1, u2, n1, n2
            !this subroutine calculate normal distributed random numbers
            call random_number(u1)
            call random_number(u2)
            n1 = dsqrt(-2d0* dlog(u1)*dcos(2 * pi * u2))
            n2 = sign(n1, u2-0.5d0)
        end subroutine
    end module math