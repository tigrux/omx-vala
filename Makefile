MODULES="gobject-2.0 gthread-2.0 gmodule-2.0 gstreamer-0.10 libomxil-bellagio"
CFLAGS=`pkg-config $(MODULES) --cflags` -I . -Wall -ggdb

all: omx-mp3-player gomx-mp3-player libgstgomx.so

%%.o: %.c


omx-mp3-player: omx-mp3-player.o
	$(CC) `pkg-config  gobject-2.0 libomxil-bellagio --libs` $^ -o $@

omx-mp3-player.c: omx-mp3-player.vala libomxil-bellagio.vapi omx.vapi
	valac -C $^
	touch $@


gomx-mp3-player: gomx-mp3-player.o gomx.o
	$(CC) `pkg-config gobject-2.0 gthread-2.0 gmodule-2.0 --libs` $^ -o $@

gomx-mp3-player.c: gomx-mp3-player.vala omx.vapi gomx.vapi
	valac -C --thread --pkg gmodule-2.0 $^
	touch $@


gomx.vapi: gomx.c

gomx.c: gomx.vala omx.vapi
	valac --vapi=gomx.vapi --pkg gmodule-2.0 --pkg posix -C -H gomx.h --target-glib=2.18 $^
	touch $@


libgstgomx.so: gstgomx.o
	$(CC) -shared -fPIC `pkg-config gstreamer-0.10 --libs` $^ -o $@

gstgomx.o: gstgomx.c
	$(CC) -fPIC $(CFLAGS) $^ -c -o $@

gstgomx.c: gstgomx.vala
	valac gstgomx.vala --pkg gstreamer-0.10 -C


clean:
	rm -f *.o *.c *~ omx-mp3-player gomx-mp3-player libgstgomx.so gomx.vapi gomx.h
