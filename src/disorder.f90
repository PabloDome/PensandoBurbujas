module disorder
    use global
    implicit none
    real(8), dimension(:,:) :: grid_disorder_centers(n_disorder,2)
    real(8), dimension(:,:) :: grid_disorder_gradients_x(n_grad_disorder, n_grad_disorder)
    real(8), dimension(:,:) :: grid_disorder_gradients_y(n_grad_disorder, n_grad_disorder)

contains
    subroutine fill_potential_centres()
        implicit none

        call random_number(grid_disorder_centers)
        grid_disorder_centers(i,j) =

    end subroutine

    subroutine disorder_potential()
        implicit none

        dexp( -0.5*(grid_disorder_centers(:,1)**2) )

    end subroutine
end module disorder