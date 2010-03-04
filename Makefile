MODULES="gobject-2.0 gthread-2.0 gmodule-2.0"
CFLAGS=`pkg-config $(MODULES) --cflags` -I . -Wall -ggdb

all: omx-mp3-player gomx-mp3-player

%%.o: %.c


omx-mp3-player: omx-mp3-player.o
	$(CC) `pkg-config $(MODULES) libomxil-bellagio --libs` $^ -o $@

omx-mp3-player.c: omx-mp3-player.vala libomxil-bellagio.vapi omx.vapi
	valac -C $^
	touch $@


gomx-mp3-player: gomx-mp3-player.o gomx.o
	$(CC) `pkg-config $(MODULES) --libs` $^ -o $@

gomx-mp3-player.c: gomx-mp3-player.vala omx.vapi gomx.vapi
	valac -C --thread --pkg gmodule-2.0 $^
	touch $@

gomx.c: gomx.vapi

gomx.vapi: gomx.vala omx.vapi
	valac --vapi=gomx.vapi --pkg gmodule-2.0 --pkg posix -C -H gomx.h $^
	touch $@


clean:
	rm -f *.o *.c *~ omx-mp3-player gomx-mp3-player gomx.vapi gomx.h
