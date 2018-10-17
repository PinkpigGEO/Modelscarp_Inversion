module rf_types

  !
  ! Copyright (c) 2013 Australian National University
  !
  ! This program is is free software: you can redistribute it and/or
  ! modify it under the terms of the GNU General Public License as
  ! publised by the Free Software Foundation, either version 3 of the
  ! License, or (at your option) any later version.
  !
  ! Authors:
  !
  !   Rhys Hawkins 
  !   Thomas Bodin
  !   Malcolm Sambridge
  !
  ! For contact information, please visit:
  !   http://www.iearth.org.au/codes/RF
  !

  use, intrinsic :: iso_c_binding

  integer, parameter :: MAX_DATA_SIZE = 200
  integer, parameter :: MAX_PARTITIONS = 10

  type :: rfdata_t
     integer :: size
     real, dimension(MAX_DATA_SIZE) :: x, y, ymodel


     integer :: show_progress
     integer :: step
     integer :: total


	    integer nl_coll
	    integer nc_coll
	    integer nl_data
	    integer nc_data
	    integer nl_EL
		integer nc_EL

	    real*4 epsilo
		real*4 alpha,beta,gama
		real*4 alpha_r,beta_r,gama_r
		real*4 pi
		real*4 Hfinal
		real*4 Hdepth
		real*4 rho_coll,rho_rock
		real*4 preexp,preexp2
		real*4 Psi_Cl36_Ca_0,lambda_36,Lambda

		logical param_inv_sr_search ! search or not the slip-rate
        real*4 param_inv_srmin ! min slip-rate
        real*4 param_inv_srmax ! min max slip-rate
        real*4 param_inv_sr  ! slip-rate when fixed
        real*4 param_inv_sr_std !Std dev. of slip-rate value change
        real*4  param_inv_preexp ! long-term history duration
        logical param_inv_qs_search ! search or not the quiescence period
        real*4 param_inv_qs ! if quiescence period searched, max age of the top (yr)
        real*4 param_inv_qs_std ! if quiescence period searched, std of the max age of the top (yr)
        integer param_inv_nevmin ! min number of events
        integer param_inv_nevmax ! max number of events
        real*4 param_inv_agemin ! min age of events
        real*4 param_inv_agemax ! max age of events
! In the move process, a partition boundary is moved by a random amount
! sampled from a Gaussian variate with a zero mean and standard deviation
! of pd. Lowering this value will increase the Move acceptance rate, however
! setting this value too low may prolong convergence.
        real*4 param_inv_pd ! Std dev. of move changes (pd)
! When perturbing the value of event ages, the new value is obtained by
! adding a random Gaussian value with a mean of 0 and this standard
! deviation. Lowering this value will increase the acceptance rate
! of the Value process, however setting too low a value may prolong
! convergence.
        real*4 param_inv_age_std ! Std dev. of age value changes
! When creating a new partition (layer) the new value of Vs for the
! partition is obtained by adding to the previous value a random
! Gaussian value with a mean of 0 and this standard deviation. The
! death process (removing a layer) also uses this value. It is
! generally fine to leave this value the same as vs_std, but it
! may be adjusted lower to improve the birth and death acceptance
! rates.
        real*4 param_inv_age_stdbd ! Standart dev. of birth/death events
        integer param_inv_burnin ! Number of iterations to be thrown away
        integer param_inv_total  ! total number of iteration
! Seed and seed_mult control the initialisation of the random number
! generator. In the serial code, only the seed value is used. In the MPI
! code, the seed is generated by constructing a seed value from seed +
! mpi_rank * seed_mult.
        integer param_inv_seed   ! seed for random
        integer param_inv_seedmult   ! seed for random
        real*4 param_inv_ci ! credible interval

    real, dimension(:,:), allocatable :: data_rock
    real, dimension(1,62) :: data_coll
    real, dimension(:,:), allocatable :: data_sf

  real, dimension(:), allocatable :: EL_ti
  real, dimension(:), allocatable :: EL_it
  real, dimension(:), allocatable :: EL_f
  real, dimension(:), allocatable :: EL_mu

        real*4 Zs(5000)
        real*8 S_s(5000)
        real*4 so_f_beta_inf
        real*4 Lambda_f_beta_inf
        real*4 so_f_e
        real*4 Lambda_f_e

  end type rfdata_t


end module rf_types
