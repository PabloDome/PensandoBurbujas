module disorder
    use global
    implicit none
    integer, parameter :: n_disorder = 1000
    real(8), parameter :: disorder_amplitude = 0.15d0, disorder_width=0.03d0
    real(8), dimension(:,:) :: disorder_centers(n_disorder,2)
    real(8), dimension(:) :: disorder_values(n_disorder)

contains
    subroutine fill_potential_centres()
        implicit none
        call random_number(disorder_centers)
        disorder_centers = disorder_centers * 4d0 - 2d0
        call random_number(disorder_values)
        disorder_values = floor(disorder_values*3-1) * disorder_amplitude
    end subroutine

    subroutine disorder_potential(r,pot)
        implicit none
        integer :: i
        real(8), intent(out) :: pot
        real(8), intent(in), dimension(2) :: r
        real(8), dimension(2) :: d
        
        pot = 0d0
        do i =1, n_disorder
            d = r-disorder_centers(i,:)
            pot = pot + disorder_values(i) * dexp(-dot_product(d,d)/2d0/disorder_width**2)
        end do
    end subroutine

    subroutine disorder_force(r, force)
        implicit none
        integer :: i
        real(8), intent(out) :: force(2)
        real(8), intent(in), dimension(2) :: r
        real(8), dimension(2) :: d
        
        force = [0d0,0d0]
        do i =1, n_disorder
            d = r-disorder_centers(i,:)
            force = force + disorder_values(i) * d * dexp(-dot_product(d,d)/2d0/disorder_width**2)
        end do
    end subroutine
end module disorder