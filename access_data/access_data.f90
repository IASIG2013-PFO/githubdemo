!***********************************************************************************************************!
!***********************************************************************************************************!
!***********************************************************************************************************!
!MODULE ACCESS_DATA
!Ce module contient les fonctions n�cessaires pour r�cup�rer les donn�es stock�es dans les tables:
!SIF, SXY, PAXY
!   -NUMRECORD, retourne le nombre d'enregistrements des diff�rents fichiers
!   -READFILE, lit les fichiers et retourne un tableau de donn�es, ainsi que le nombre d'enregistrements
!   -SPLIT, ce charge de s�parer une ligne du fichier en �l�ment indic�.
!***********************************************************************************************************!

module access_data
implicit none
contains
!***********************************************************************************************************!
!-----------------------------
!SUBROUTINE
subroutine READFILE(pathFile, tab, n)
!READFILE, lit les fichiers et retourne un tableau de donn�es, ainsi que le nombre d'enregistrements
!   -
!-----------------------------
!Specification

    character(200), intent(in)      ::pathFile
    character(1),  intent(out),allocatable, dimension(:,:,:)      ::tab
    integer, intent(in)             ::n

!-----------------------------
!Declaration
    logical                         ::exist
    integer                         ::io,  i, nelmt
    character(20)                   ::str
    character(1)                    ::sep
    integer, dimension(3)     ::elmt

!-----------------------------

!-----------------------------
!Body
    allocate(tab(n,n,n))
    tab(1,1,1) = "0"
    inquire(file=pathFile,exist= exist)
    if (.NOT. exist) then
        print *, "No such file"
        return
    endif
    print *, pathFile

    !Ouverture du fichier
    open(10, file=pathFile)
    !Lecture du fichier
    do
        read(10,1000,iostat=io)str
        !Test de fin de fichier
        if(io < 0) exit
        sep = ";"
        print *, "Appel de SPLIT"
        call SPLIT(str, sep, elmt, nelmt)
        do i = 1, nelmt
            print *, elmt(i)
        end do

    enddo
    !Fermeture du fichier
    close(10)

deallocate (tab)
1000 FORMAT(a10)
end subroutine READFILE

!***********************************************************************************************************!
!-----------------------------
!SUBROUTINE
subroutine NUMRECORD(pathFile, n)
!READFILE, lit les fichiers et retourne un tableau de donn�es, ainsi que le nombre d'enregistrements

!-----------------------------
!Specification

    character(200), intent(in)      ::pathFile
    integer, intent(out)            ::n

!-----------------------------
!Declaration
    logical                         ::exist
    integer                         ::io

    n = 0
!-----------------------------
!Body
    inquire(file=pathFile,exist= exist)
    if (.NOT. exist) then
        print *, "No such file"
        return
    endif

    !Ouverture du fichier
    open(10, file=pathFile)
    !Lecture du fichier
    do
        read(10,*,iostat=io)
        !Test si fin du fichier
        if(io < 0) exit
        n = n + 1

    enddo
    !Fermeture du fichier
    close(10)

end subroutine NUMRECORD


!***********************************************************************************************************!
!-----------------------------
!SUBROUTINE
subroutine SPLIT(str, sep, T, n)
!SPLIT, ce charge de s�parer une ligne du fichier en �l�ment indic�.
!   -str :: la cha�ne de caract�re � traiter
!   -sep :: le s�parateur d'�l�ments
!   - T :: le tableau d'�l�ment qui sera retourn�. La taille peut-�tre variable (XY ou XYZ, etc.)
!   - n :: le nombred'�l�ment dans le tabeau.

!-----------------------------
!Specification
    character(20), intent(in)       ::str
    character(1), intent(in)       ::sep
    integer, dimension(:), intent(out) ::T
    integer, intent(out)            ::n

!-----------------------------
!Declaration
    integer             :: pos1, pos2, val

!-----------------------------
!Body
    pos1 = 1
    n = 0

   do
        pos2 = index( str(pos1:len_trim(str)),sep)
        if (pos2 == 0) then
            n = n + 1
            !Convertir la cha�ne de caract�re en entier
            read(str(pos1:), *) val
            T(n) = val
            exit
        end if
        n = n + 1
        !Convertir la cha�ne de caract�re en entier
        read(str(pos1:pos1 + pos2 - 2), *) val
        T(n) = val
        pos1 = pos1 + pos2
    end do

end subroutine SPLIT

end module access_data

!-----------------------------
!PROGRAM

program MAIN
!This program read the SIF and SXY file of a Graph
!-----------------------------
use access_data
!Declaration
    implicit none
    character(200)          ::pathUncleaned
    character(1),allocatable, dimension(:,:,:)      ::tab
    integer                 ::n
!-----------------------------

!-----------------------------
!Body
    pathUncleaned = "E:\Python\graphe\SIFF.txt"
    print *, "appel de la subroutine NUMRECORD"
    call NUMRECORD(pathUncleaned, n)
    print *, "Nombre de ligne dans le fichier ", n
    !allocate(tab(n,n,n))

    print *, "appel de la subroutine READFILE"
    call READFILE(pathUncleaned, tab, n)
    print *, "Fin de l'appel de subroutine"

end program MAIN
!-----------------------------
