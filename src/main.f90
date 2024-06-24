program n_springs
    use global
    use math
    use initial_conditions
    use dynamics
    implicit none
    integer:: i
    real(8) :: r_mean, r_std, v_mean, v_std, disorder_0

    n_dim = 2
    n_particles = 500
    R0 = 1d0
    k_m = 0.1d0
    drag_m = 0.5d0
    disorder_0 = 0.2d0
    n_disorder = 100
    n_grad_disorder = 1000
    grid_disorder_min = -3d0
    grid_disorder_max = 3d0
    pot_max = 1d0
    pot_width = 1d0



    allocate(r0_vec(n_particles, n_dim), r_vec(n_particles, n_dim))
    allocate(v_vec(n_particles, n_dim), v0_vec(n_particles, n_dim))
    allocate(a_vec(n_particles, n_dim))

    call set_initial(.True., disorder_0) ! distribuye las partículas en un poligono
    r_vec = r0_vec
    call calculate_accel()
    do i = 1, n_particles
        write(100,*)r_vec(i,1), r_vec(i,2)
    end do

    pressure = 0.01d0
    do i = 1, 10000
        call evolve_one_step(0.01d0, 1)
        call get_mean_values(r_mean, r_std, v_mean, v_std)
        if(mod(i, 10) == 0) then
            write(200,*) r_mean, r_std, v_mean, v_std
        end if
    end do
    print*,'presure turned off'

    do i = 1, n_particles
        write(300,*)r_vec(i,1), r_vec(i,2)
    end do

    pressure = -0.01d0
    do i = 1, 10000
        call evolve_one_step(0.01d0, 1)
        call get_mean_values(r_mean, r_std, v_mean, v_std)
        if(mod(i, 10) == 0) then
            write(200,*) r_mean, r_std, v_mean, v_std
        end if
    end do
    print*,'presure turned off'

    do i = 1, n_particles
        write(400,*)r_vec(i,1), r_vec(i,2)
    end do

    ! pressure = 0d0
    do i = 1, 2000
        call evolve_one_step(0.01d0, 1)
        call get_mean_values(r_mean, r_std, v_mean, v_std)
        if(mod(i, 10) == 0) then
            write(200,*) r_mean, r_std, v_mean, v_std
        end if
    end do
    do i = 1, n_particles
        write(500,*)r_vec(i,1), r_vec(i,2)
    end do
end program