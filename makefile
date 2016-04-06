FORTRAN = gfortran
FFLAGS = -c 
MEX = C:/Program\ Files\ (x86)/MATLAB/R2012a\ Student/bin/mex.bat

OBJS=\
cfmm2dpart.o\
d2mtreeplot.o\
d2tstrcr_omp.o\
l2dterms.o\
laprouts2d.o\
lfmm2drouts.o\
prini.o\
rfmm2dpart.o\
laplaceSLP.o

mex: laplaceSLPfmm.F $(OBJS)
	$(MEX) laplaceSLPfmm.F $(OBJS)

cfmm2dpart.o: cfmm2dpart.f
	$(FORTRAN) $(FFLAGS) cfmm2dpart.f

d2mtreeplot.o: d2mtreeplot.f
	$(FORTRAN) $(FFLAGS) d2mtreeplot.f

d2tstrcr_omp.o: d2tstrcr_omp.f
	$(FORTRAN) $(FFLAGS) d2tstrcr_omp.f

l2dterms.o: l2dterms.f
	$(FORTRAN) $(FFLAGS) l2dterms.f

laprouts2d.o: laprouts2d.f
	$(FORTRAN) $(FFLAGS) laprouts2d.f

lfmm2drouts.o: lfmm2drouts.f
	$(FORTRAN) $(FFLAGS) lfmm2drouts.f

prini.o: prini.f
	$(FORTRAN) $(FFLAGS) prini.f

rfmm2dpart.o: rfmm2dpart.f
	$(FORTRAN) $(FFLAGS) rfmm2dpart.f

laplaceSLP.o: laplaceSLP.f
	$(FORTRAN) $(FFLAGS) laplaceSLP.f

clean: 
	rm *.o
