MODULES="gobject-2.0 gthread-2.0 gmodule-2.0"
CFLAGS=`pkg-config $(MODULES) --cflags` -I . -Wall -ggdb

all: simple-mp3-player gomx-mp3-player

%%.o: %.c


simple-mp3-player: simple-mp3-player.o
	$(CC) `pkg-config $(MODULES) libomxil-bellagio --libs` $^ -o $@

simple-mp3-player.c: simple-mp3-player.vala libomxil-bellagio.vapi omx.vapi
	valac -C $^


gomx-mp3-player: gomx-mp3-player.o gomx.o
	$(CC) `pkg-config $(MODULES) --libs` $^ -o $@

gomx-mp3-player.c: gomx-mp3-player.vala omx.vapi gomx.vapi
	valac -C --thread --pkg gmodule-2.0 $^

gomx.vapi gomx.c: gomx.vala omx.vapi
	valac --vapi=gomx.vapi --pkg gmodule-2.0 -C -H gomx.h $^


clean:
	rm -f *.o *.c *~ simple-mp3-player gomx-mp3-player gomx.vapi gomx.h
