PROG =	dmat2

SRCS =	ks_array_module.f90 ks_matrix_module.f90 main.f90 matrix.f90 \
	matrix_mapping.f90 numbers.f90 proc_mapping.f90 \
	scalapack_interfaces.f90 blac_interfaces.f90

OBJS =	ks_array_module.o ks_matrix_module.o main.o matrix.o matrix_mapping.o \
	numbers.o proc_mapping.o scalapack_interfaces.o blacs_interfaces.o

LIBS =-lblacs-openmpi -lblacsF77init-openmpi -lscalapack-openmpi -llapack -lblas	

CC = cc
CFLAGS = -O
FC = mpif90
FFLAGS = -O -g -std=f2008 -Wall -Wextra -Wimplicit-interface -Wuse-without-only -fcheck=all -finit-real=snan
F90 = mpif90
F90FLAGS = -O -g -std=f2008 -Wall -Wextra -Wimplicit-interface -Wuse-without-only -fcheck=all -finit-real=snan
LDFLAGS = -fbacktrace -g 

all: $(PROG)

$(PROG): $(OBJS)
	$(F90) $(LDFLAGS) -o $@ $(OBJS) $(LIBS)

clean:
	rm -f $(PROG) $(OBJS) *.mod

.SUFFIXES: $(SUFFIXES) .f90

%.o: %.mod

.f90.o:
	$(F90) $(F90FLAGS) -c $<

ks_array_module.o: ks_matrix_module.o numbers.o
ks_matrix_module.o: matrix.o numbers.o
main.o: ks_array_module.o ks_matrix_module.o matrix.o numbers.o
matrix.o: matrix_mapping.o numbers.o scalapack_interfaces.o
matrix_mapping.o: numbers.o proc_mapping.o blacs_interfaces.o
proc_mapping.o: 
scalapack_interfaces.o: numbers.o
blacs_interfaces.o: 
