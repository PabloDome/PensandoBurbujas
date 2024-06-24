module global
    implicit none
    real(8) :: k_m, drag_m, pressure
    real(8) :: pot_max, pot_width, grid_disorder_min, grid_disorder_max
    real(8), allocatable, dimension(:,:) :: r0_vec, r_vec, v0_vec, v_vec, a_vec
    integer :: n_particles, n_dim, n_disorder, n_grad_disorder
end module global