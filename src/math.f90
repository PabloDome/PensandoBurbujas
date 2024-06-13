module math
    use global
    implicit none
    real(8), parameter :: pi = 3.14159265359d0

    contains
        subroutine get_mean_values(r_mean, r_std, v_mean, v_std)
            implicit none
            real(8) :: r_mean, r_std, v_mean, v_std

            r_mean = sum(dsqrt(r_vec(:,1)**2+r_vec(:,2)**2))/n_particles
            r_std = dsqrt(sum( (dsqrt(r_vec(:,1)**2+r_vec(:,2)**2) - r_mean)**2)/n_particles)
            v_mean = sum(dsqrt(v_vec(:,1)**2+v_vec(:,2)**2))/n_particles
            v_std = dsqrt(sum( (dsqrt(v_vec(:,1)**2+v_vec(:,2)**2) - v_mean)**2)/n_particles)

        end subroutine
end module math