      subroutine laplaceSLP(den,xs,ys,ns,dx,dy)
c     Evaluates the gradient of the single-layer potential for Laplace's
c     equation.
c     den is the source strength of length ns
c     xs and ys are the source/target points
c     (dx,dy) are the two components of the gradient of the single-layer
c     potential
      implicit real*8 (a-h,o-z)

      integer error
      real *8 den(ns)
c     strength of Laplace SLP
      real *8 xs(ns),ys(ns)
c     location of the source points
      real *8 dx(ns),dy(ns)
c     gradient of potential
      
      real *8, allocatable :: sources(:,:)
c     location of sources/targets
      real *8, allocatable :: charges(:)
c     charge strength of single-layer potential term
      real *8, allocatable :: dipstr(:),dipvec(:,:)
c     dipole strength and dipole vector which we won't need
      real *8, allocatable :: pot(:),grad(:,:),hess(:,:)
c     potential, gradient, and hessian

      allocate(sources(2,ns),stat=error)
      allocate(charges(ns),stat=error)
      allocate(dipstr(ns),stat=error)
      allocate(dipvec(2,ns),stat=error)
      allocate(pot(ns),stat=error)
      allocate(grad(2,ns),stat=error)
      allocate(hess(3,ns),stat=error)

      ifpot = 0
      ifgrad = 1
      ifhess = 0
c     set flags for what output values we require

      do i=1,ns
        sources(1,i) = xs(i)
        sources(2,i) = ys(i)
      enddo
c     set source locations

c     START OF FORMING FIRST COMPONENET OF VELCOTIY
      ifcharge = 1 ! charge component
      ifdipole = 0 ! no dipole componenet

      do i=1,ns
        charges(i) = den(i)
      enddo

      call rfmm2dpart(ierr,5,ns,sources,
     $   ifcharge,charges,ifdipole,dipstr,dipvec,
     $   ifpot,pot,ifgrad,grad,ifhess,hess)
c     compute the gradient of Laplace SLP


      twopi = 8.d0*datan(1.d0)
      do i=1,ns
        dx(i) = grad(1,i)/twopi
        dy(i) = grad(2,i)/twopi
      enddo


      end
 
