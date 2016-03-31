      subroutine laplaceSLP(den,xs,ys,ns,xt,yt,nt,
     $      rifpot,rifgrad,rifhess,riequal,riprec,
     $      pot,dx,dy,dxx,dxy,dyy)
c     Evaluates the single-layer potential for Stokes' equation
c     (s1,s2) is the source strength of length ns
c     xs and ys are the source points and xt and yt are the target 
c     locations of length ns
c     iequal is 1 if sources .eq. targest
c     iequal is 0 if sources .ne. targets
c     iprec controls the accuracy of the FMM
c         -2 => tolerance =.5d0
c         -1 => tolerance =.5d-1
c          0 => tolerance =.5d-2
c          1 => tolerance =.5d-3
c          2 => tolerance =.5d-6
c          3 => tolerance =.5d-9
c          4 => tolerance =.5d-12
c          5 => tolerance =.5d-15
c     (u1,u2) are the two components of the velocity field
      implicit real*8 (a-h,o-z)

      integer error
      real *8 den(ns)
c     strength of Laplace SLP
      real *8 xs(ns),ys(ns)
c     location of the source points
      real *8 xt(nt),yt(nt)
c     location of the target points
      real *8 pot(nt)
c     potential
      real *8 dx(nt),dy(nt),grad(2,nt)
c     gradient of potential
      real *8 dxx(nt),dxy(nt),dyy(nt),hess(3,nt)
c     hessian of potential
      real *8 trash(3,nt)
      
      real *8, allocatable :: sources(:,:)
c     location of sources
      real *8, allocatable :: targets(:,:)
c     location of targets
      real *8, allocatable :: charges(:)
c     charge strength of single-layer potential term

c      CHARACTER*120 LINE 
c      INTEGER*4 MEXPRINTF,K
c      WRITE(LINE,*) 'ARG = ',rifhess
c      K = MEXPRINTF(LINE//ACHAR(13))

      allocate(targets(2,nt),stat=error)
      allocate(sources(2,ns),stat=error)
      allocate(charges(ns),stat=error)

      twopi = 8.d0*datan(1.d0)

      iequal = int(riequal)
c     Flag for weather source and target locations are the same
      iprec = int(riprec)
c     precision of the FMM
      ifpot = int(rifpot)
      ifgrad = int(rifgrad)
      ifhess = int(rifhess)
c     set flags for what output values we require


      do i=1,ns
        sources(1,i) = xs(i)
        sources(2,i) = ys(i)
      enddo
c     set source locations
      do i=1,nt
        targets(1,i) = xt(i)
        targets(2,i) = yt(i)
      enddo
c     set target locations

c     START OF FORMING FIRST COMPONENET OF VELCOTIY
      ifcharge = 1 ! charge component
      ifdipole = 0 ! no dipole componenet

      do i=1,ns
        charges(i) = den(i)
      enddo

      if (iequal .eq. 1) then
        call rfmm2dpart(ierr,iprec,ns,sources,
     $     ifcharge,charges,ifdipole,dipstr,dipvec,
     $     ifpot,pot,ifgrad,grad,ifhess,hess)
      else
        call rfmm2dparttarg(ierr,iprec,ns,sources,
     $     ifcharge,charges,ifdipole,dipstr,dipvec,
     $     ifpot,trash,ifgrad,trash,ifhess,trash,
     $     nt,targets,ifpot,pot,ifgrad,grad,
     $     ifhess,hess)
      endif
c     compute the Laplace SLP

      if (ifpot .eq. 1) then
        do i=1,nt
          pot(i) = pot(i)/twopi
        enddo
      else
        do i=1,nt
          pot(i) = 0.d0
        enddo
      endif

      if (ifgrad .eq. 1) then
        do i=1,nt
          dx(i) = grad(1,i)/twopi
          dy(i) = grad(2,i)/twopi
        enddo
      else
        do i=1,nt
          dx(i) = 0.d0
          dy(i) = 0.d0
        enddo
      endif

      if (ifhess .eq. 1) then
        do i=1,nt
          dxx(i) = hess(1,i)/twopi
          dxy(i) = hess(2,i)/twopi
          dyy(i) = hess(3,i)/twopi
        enddo
      else
        do i=1,nt
          dxx(i) = 0.d0
          dxy(i) = 0.d0
          dyy(i) = 0.d0
        enddo
      endif



      end
 
