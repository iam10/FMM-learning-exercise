      program testCall
      implicit real*8 (a-h,o-z)

      parameter (ns = 2**10)
      parameter (nt = ns)

      dimension den(ns)
      dimension xs(ns),ys(ns)
      dimension xt(nt),yt(nt)
      dimension pot(nt),dx(nt),dy(nt)
      dimension dxx(nt),dxy(nt),dyy(nt)
      dimension pot2(nt),dx2(nt),dy2(nt)

      twopi = 8.d0*datan(1.d0)

      dtheta = twopi/dble(ns)
      do i=1,ns
        theta = dble(i-1)*dtheta
        xs(i) = dcos(theta)
        ys(i) = 0.5d0*dsin(theta)
        den(i) = 2.d0*dcos(theta)
      enddo
      dtheta = twopi/dble(nt)
      do i=1,nt
        theta = dble(i-1)*dtheta
        xt(i) = 0.5d0*dcos(theta) + 2.d0
        yt(i) = dsin(theta) + 1.d0
      enddo

      rifpot = 1.d0
      rifgrad = 1.d0
      rifhess = 0.d0
      call laplaceSLP(den,xs,ys,ns,xs,ys,ns,
     $    rifpot,rifgrad,rifhess,1.d0,4.d0,
     $    pot,dx,dy,dxx,dxy,dyy)

c      call laplaceSLP(den,xs,ys,ns,xt,yt,nt,
c     $    ifpot,ifgrad,1.d0,4.d0,pot,dx,dy)
c
c      error = 0.0d0
c      do i = 1,nt
c        error = error + (pot(i) - pot2(i))**2.d0
c      enddo
c      error = dsqrt(error)
c      print*,error
c



      end





