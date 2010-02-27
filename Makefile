MODULES="gobject-2.0 gthread-2.0 gmodule-2.0"
CFLAGS=`pkg-config $(MODULES) --cflags` -I . -Wall -ggdb

all: simple-mp3-player class-mp3-player

%%.o: %.c


simple-mp3-player: simple-mp3-player.o
	$(CC) `pkg-config $(MODULES) libomxil-bellagio --libs` $^ -o $@

simple-mp3-player.c: simple-mp3-player.vala
	valac $^ -C --pkg libomxil-bellagio --vapidir .
	touch $@


class-mp3-player: class-mp3-player.o omx-glib.o
	$(CC) `pkg-config $(MODULES) --libs` $^ -o $@

class-mp3-player.c omx-glib.c: class-mp3-player.vala omx-glib.vala
	valac --thread $^ -C --pkg omx --pkg gmodule-2.0 --vapidir .
	touch $@


clean:
	rm -f *.o *.c *~ simple-mp3-player class-mp3-player
