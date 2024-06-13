module global
    implicit none
    real(8), allocatable, dimension(:,:) :: r0_vec, r_vec, v0_vec, v_vec, a_vec
    integer :: n_particles, n_dim
end module global