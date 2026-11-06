#
# make		Build 6309 version
# make clean	Remove all binary and listing files
# make 6809	Build 6809 version
# make backup	Save backup of current source files
#

all:	6809

6809: main.asm
	lwasm --list -3 -b -o SAUCERS.BIN main.asm > saucers.lst
ifneq ("$(wildcard /media/share1/COCO/drive0.dsk)","")
	decb copy -r -2 -b SAUCERS.BIN /media/share1/COCO/drive0.dsk,SAUCERS.BIN
endif

clean:
	rm -f *.bin *.lst

backup:
	tar -cvf backups/`date +%Y-%m-%d_%H-%M-%S`.tar Makefile *.asm notes
