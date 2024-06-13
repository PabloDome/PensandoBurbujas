program n_springs
    use global
    use math
    use initial_conditions
    use dynamics
    implicit none
    integer:: i
    real(8) :: r_mean, r_std, v_mean, v_std

    n_dim = 2
    n_particles = 20
    R0 = 1d0

    allocate(r0_vec(n_particles, n_dim), r_vec(n_particles, n_dim))
    allocate(v_vec(n_particles, n_dim), v0_vec(n_particles, n_dim))
    allocate(a_vec(n_particles, n_dim))

    call set_initial() ! distribuye las partículas en un poligono
    r_vec = r0_vec
    call calculate_accel(0.1d0,0.1d0,0.05d0)

    do i = 1, n_particles
        write(100,*)r0_vec(i,1), r0_vec(i,2), v0_vec(i,1), v0_vec(i,2), a_vec(i,1), a_vec(i,2)
    end do

    do i = 1, 1000000
        call evolve_one_step(0.05d0, 0.1d0, 0.1d0, 0.1d0, 0)
        call get_mean_values(r_mean, r_std, v_mean, v_std)
        write(200,*) r_mean, r_std, v_mean, v_std
    end do
    do i = 1, n_particles
        write(100,*)r_vec(i,1), r_vec(i,2), v_vec(i,1), v_vec(i,2), a_vec(i,1), a_vec(i,2)
    end do    

end program