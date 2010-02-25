MODULE="libomxil-bellagio gobject-2.0 gthread-2.0"
CFLAGS=`pkg-config $(MODULE) --cflags` -I . -Wall -ggdb
LDFLAGS=`pkg-config $(MODULE) --libs`

all: simple-mp3-player class-mp3-player

simple-mp3-player: simple-mp3-player.o
simple-mp3-player.o: simple-mp3-player.c
simple-mp3-player.c: simple-mp3-player.vala
	valac $^ -C --pkg libomxil-bellagio --vapidir .
	touch $@

class-mp3-player: class-mp3-player.o
class-mp3-player.o: class-mp3-player.c
class-mp3-player.c: class-mp3-player.vala
	valac --thread $^ -C --pkg libomxil-bellagio --vapidir .
	touch $@

clean:
	rm -f *.o *.c *~ simple-mp3-player class-mp3-player
