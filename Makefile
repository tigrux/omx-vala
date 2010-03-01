MODULES="gobject-2.0 gthread-2.0 gmodule-2.0"
CFLAGS=`pkg-config $(MODULES) --cflags` -I . -Wall -ggdb

all: simple-mp3-player class-mp3-player

%%.o: %.c


simple-mp3-player: simple-mp3-player.o
	$(CC) `pkg-config $(MODULES) libomxil-bellagio --libs` $^ -o $@

simple-mp3-player.c: simple-mp3-player.vala libomxil-bellagio.vapi omx.vapi
	valac -C $^
	touch $@


class-mp3-player: class-mp3-player.o omx-glib.o
	$(CC) `pkg-config $(MODULES) --libs` $^ -o $@

class-mp3-player.c: class-mp3-player.vala omx.vapi omx-glib.vapi
	valac -C --thread --pkg gmodule-2.0 $^
	touch $@

omx-glib.vapi: omx-glib.vala omx.vapi
	valac --vapi=omx-glib.vapi --pkg gmodule-2.0 -C -H omx-glib.h $^
	touch $@


clean:
	rm -f *.o *.c *~ simple-mp3-player class-mp3-player
