program n_springs
    use global
    use math
    use initial_conditions
    use dynamics
    use disorder
    implicit none
    integer:: i, j
    real(8) :: r_mean, r_std, v_mean, v_std, disorder_0, pot, force(2)

    n_dim = 2
    n_particles = 200
    R0 = 1d0
    k_m = 0.5d0
    drag_m = 0.05d0
    disorder_0 = 0.1d0

    allocate(r0_vec(n_particles, n_dim), r_vec(n_particles, n_dim))
    allocate(v_vec(n_particles, n_dim), v0_vec(n_particles, n_dim))
    allocate(a_vec(n_particles, n_dim))

    
    ! Creating random forces 
    call fill_potential_centres()
    !for plotting purposes
    do i = 1, 100
        do j =1, 100
            call disorder_potential([i*0.04d0-2d0, j*0.04d0-2d0], pot)
            call disorder_force([i*0.04d0-2d0, j*0.04d0-2d0], force)
            write(600,*)i*0.04d0-2d0, j*0.04d0-2d0, pot, force(1), force(2)
        end do
        write(600,*)
    end do

    ! initial positions of particles
    call set_initial(.True., disorder_0) ! distribuye las partículas en un poligono    
    r_vec = r0_vec
    call calculate_accel()
    do i = 1, n_particles
        write(100,*)r_vec(i,1), r_vec(i,2)
    end do

    pressure = 0.005d0
    do i = 1, 2000
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

    pressure = -0.005d0
    do i = 1, 2000
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

    pressure = 0d0
    do i = 1, 20000
        call evolve_one_step(0.01d0, 1)
        call get_mean_values(r_mean, r_std, v_mean, v_std)
        if(mod(i, 10) == 0) then
            write(200,*) r_mean, r_std, v_mean, v_std
        end if
        if (mod(i,2000) == 0) then
            do j = 1, n_particles
                write(i,*)r_vec(j,1), r_vec(j,2)
            end do
        end if
    end do
    do i = 1, n_particles
        write(500,*)r_vec(i,1), r_vec(i,2)
    end do
end program