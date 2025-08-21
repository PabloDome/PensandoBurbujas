module global
    implicit none
    real(8) :: k_m, drag_m, pressure, cut_dist
    real(8), allocatable, dimension(:,:) :: r0_vec, r_vec, v0_vec, v_vec, a_vec
    real(8), allocatable, dimension(:) :: r_cm, v_cm
    integer :: n_particles, n_dim
end module global