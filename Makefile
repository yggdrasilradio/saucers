
all:	6809

6809: main.asm
	lwasm --list -3 -b -o redistribute/saucers.bin main.asm > saucers.lst
ifneq ("$(wildcard /media/share1/COCO/drive0.dsk)","")
	decb copy -r -2 -b redistribute/saucers.bin /media/share1/COCO/drive0.dsk,SAUCERS.BIN
endif
	rm -f redistribute/saucers.dsk
	decb dskini redistribute/saucers.dsk
	decb copy -r -2 -b redistribute/saucers.bin redistribute/saucers.dsk,SAUCERS.BIN

clean:
	rm -f *.bin *.lst

backup:
	tar -cvf backups/`date +%Y-%m-%d_%H-%M-%S`.tar Makefile *.asm notes
