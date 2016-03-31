      subroutine laplaceSLPdirect(den,xs,ys,ns,xt,yt,nt,iequal,
     $   pot,dx,dy)

      implicit real*8 (a-h,o-z)

      real *8 den(ns)
      real *8 xs(ns),ys(ns)
      real *8 xt(nt),yt(nt)
      real *8 pot(nt),dx(nt),dy(nt)

      twopi = 8.d0*datan(1.d0)

      do i=1,nt
        pot(i) = 0.d0
        dx(i) = 0.d0
        dy(i) = 0.d0
        do j=1,ns
          if ((i .ne. j .and. iequal .eq. 1) .or. iequal .eq. 0) then
            dis2 = (xt(i) - xs(j))**2.d0 + (yt(i) - ys(j))**2.d0
            pot(i) = pot(i) + 5.d-1*dlog(dis2)*den(j)

            dx(i) = dx(i) + (xt(i) - xs(j))/dis2*den(j) 
            dy(i) = dy(i) + (yt(i) - ys(j))/dis2*den(j) 
          endif
        enddo
        pot(i) = pot(i)/twopi
        dx(i) = dx(i)/twopi
        dy(i) = dy(i)/twopi
      enddo


      end
