Module proc_mapping_module

  !! Module to deal with the MPI processes used by dmat2

  Implicit None

  Type, Public :: proc_mapping
     !! An instance of a processor map
     Character( Len = 128 ), Private   :: name                         !! Name of the processor map
     Integer               , Private   :: communicator                 !! The communicator spanning the processors used
   Contains
     ! Public methods
     Procedure, Public  :: print    => print_proc_mapping      !! Print information about a processor to stdout
     Procedure, Public  :: get_comm => get_comm_proc_mapping   !! Get the communicator used by the processor map
     Generic  , Public  :: set      => set_proc_mapping        !! Set a processor map
     ! Private Implementations
     Procedure, Private :: set_proc_mapping                    
  End Type proc_mapping

  Public :: proc_mapping_init
  Public :: proc_mapping_comm_to_base
  Public :: proc_mapping_finalise
  
  Private

Contains

  Subroutine proc_mapping_init
    !! Initalise the processor mapping system
    ! No internal state, yah!
  End Subroutine proc_mapping_init

  Subroutine proc_mapping_comm_to_base( comm, mapping )

    !! Turns a communicator into a processor map
    
    Integer             , Intent( In    ) :: comm
    Type( proc_mapping ), Intent(   Out ) :: mapping
    
    ! Should reall comm_dup comm and keep a record of what's in use - but internal state, yuck ... 
    Call mapping%set( 'BASE_MAP', comm )
    
  End Subroutine proc_mapping_comm_to_base

  Subroutine proc_mapping_finalise
    !! Finalise the processor mapping system
    ! Should free any commnuicators generated by the routines
  End Subroutine proc_mapping_finalise

  Subroutine print_proc_mapping( map )

    !! Print information about a processor to stdout

    Use mpi, Only : mpi_comm_size, mpi_comm_rank
    
    Class( proc_mapping ), Intent( In ) :: map

    Integer :: rank, nproc, nproc_parent
    Integer :: error

    Call mpi_comm_size( map%communicator, nproc, error )
    Call mpi_comm_rank( map%communicator, rank , error )
    If( rank == 0 ) Then
       Write( *, '( a, a, a, i0 )' ) 'Size of proc_mapping ', Trim( Adjustl( map%name ) ), ' is ', nproc
       Call mpi_comm_size( map%communicator, nproc_parent, error )
       Write( *, '( a, a, a, i0 )' ) 'Size of parent of proc_mapping ', Trim( Adjustl( map%name ) ), ' is ', nproc_parent
    End If
    
  End Subroutine print_proc_mapping

  Subroutine set_proc_mapping( map, name, communicator )

    !! Set a processor map

    Class( proc_mapping ), Intent(   Out ) :: map
    Character( Len = * ) , Intent( In    ) :: name
    Integer              , Intent( In    ) :: communicator

    map%name                = name
    map%communicator        = communicator

  End Subroutine set_proc_mapping

  Pure Function get_comm_proc_mapping( map ) Result( comm )

    !! Get the communicator used by the processor map

    Integer :: comm

    Class( proc_mapping ), Intent( In ) :: map

    comm = map%communicator

  End Function get_comm_proc_mapping
  
End Module proc_mapping_module