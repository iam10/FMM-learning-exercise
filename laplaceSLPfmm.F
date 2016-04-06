#include <fintrf.h>
C
C laplaceSLPfmm.F 
C
C This subroutine is the main gateway to MATLAB.  When a MEX function
C  is executed MATLAB calls the MEXFUNCTION subroutine in the corresponding
C  MEX file.  
C
C
      SUBROUTINE MEXFUNCTION(NLHS, PLHS, NRHS, PRHS)
C-----------------------------------------------------------------------
C     (pointer) Replace integer by integer*8 on 64-bit platforms
C
      MWPOINTER PLHS(*), PRHS(*)

C-----------------------------------------------------------------------
C

      INTEGER NLHS, NRHS
      INTEGER ERROR
      
C
C-----------------------------------------------------------------------
C     (pointer) Replace integer by integer*8 on 64-bit platforms
C
      MWPOINTER MXCREATEDOUBLEMATRIX, MXGETPR

C-----------------------------------------------------------------------
C

      MWSIZE MXGETM, MXGETN
C
C KEEP THE ABOVE SUBROUTINE, ARGUMENT, AND FUNCTION DECLARATIONS FOR USE
C IN ALL YOUR FORTRAN MEX FILES.
C---------------------------------------------------------------------
C
C-----------------------------------------------------------------------
C     (pointer) Replace integer by integer*8 on 64-bit platforms
C
      MWPOINTER DEN,XS,YS
      MWPOINTER POTX,POTY

C-----------------------------------------------------------------------
C

      MWSIZE MS, NS
      REAL *8, ALLOCATABLE :: RDEN(:),RXS(:),RYS(:)
      REAL *8, ALLOCATABLE :: RPOTX(:),RPOTY(:)

c#if defined MSWIND
C     For Windows only!
C     This resets the floating point exception to allow divide by zero,
C     overflow and invalid numbers. 
C     
c      INTEGER(2) CONTROL
c      CALL GETCONTROLFPQQ(CONTROL)
c      CONTROL = CONTROL .OR. FPCW$ZERODIVIDE
c      CONTROL = CONTROL .OR. FPCW$INVALID
c      CONTROL = CONTROL .OR. FPCW$OVERFLOW
c      CALL SETCONTROLFPQQ(CONTROL)
c#endif

C CHECK FOR PROPER NUMBER OF ARGUMENTS
C
      IF (NRHS .NE. 3) THEN
        CALL MEXERRMSGTXT('FMM requires five input arguments')
      ELSEIF (NLHS .NE. 2) THEN
        CALL MEXERRMSGTXT('FMM Requires one output argument')
      ENDIF
      

c     GET THE NUMBER OF CHARGES/SOURCES.
      MS = MXGETM(PRHS(1))
      NS = MXGETN(PRHS(1));
      MS = MAX(MS,NS)
c     MS is the number of sources/targets

      ALLOCATE(RDEN(MS),STAT=ERROR)
      ALLOCATE(RXS(MS),STAT=ERROR)
      ALLOCATE(RYS(MS),STAT=ERROR)
      ALLOCATE(RPOTX(MS),STAT=ERROR)
      ALLOCATE(RPOTY(MS),STAT=ERROR)
C
C CREATE A MATRIX FOR RETURN ARGUMENT
      PLHS(1) = MXCREATEDOUBLEMATRIX(MS,1,0)
      PLHS(2) = MXCREATEDOUBLEMATRIX(MS,1,0)
C
C ASSIGN POINTERS TO THE VARIOUS PARAMETERS
C
      DEN = MXGETPR(PRHS(1))
      XS = MXGETPR(PRHS(2))
      YS = MXGETPR(PRHS(3))
C
      POTX = MXGETPR(PLHS(1))
      POTY = MXGETPR(PLHS(2))
C
C COPY RIGHT HAND ARGUMENTS TO LOCAL ARRAYS OR VARIABLES
      CALL MXCOPYPTRTOREAL8(DEN, RDEN, MS)
      CALL MXCOPYPTRTOREAL8(XS, RXS, MS)
      CALL MXCOPYPTRTOREAL8(YS, RYS, MS)

C
C DO THE ACTUAL COMPUTATIONS IN A SUBROUTINE
C       CREATED ARRAYS.
C

      CALL laplaceSLP(RDEN,RXS,RYS,MS,RPOTX,RPOTY)

C
C COPY OUTPUT WHICH IS STORED IN LOCAL ARRAY TO MATRIX OUTPUT
      CALL MXCOPYREAL8TOPTR(RPOTX, POTX, MS)
      CALL MXCOPYREAL8TOPTR(RPOTY, POTY, MS)
C

      DEALLOCATE(RDEN)
      DEALLOCATE(RXS)
      DEALLOCATE(RYS)
      DEALLOCATE(RPOTX)
      DEALLOCATE(RPOTY)

      RETURN
      END
