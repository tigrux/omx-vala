MODULES=gobject-2.0 gthread-2.0 gmodule-2.0 gstreamer-0.10 libomxil-bellagio
CFLAGS=`pkg-config $(MODULES) --cflags` -I . -Wall -ggdb -fPIC
VALAFLAGS=-C --pkg gmodule-2.0 --pkg posix --pkg gstreamer-0.10 --target-glib=2.18

all: gomx-mp3-player libgstgomx.so

%%.o: %.c


gomx-mp3-player: gomx-mp3-player.o gomx.o
	$(CC) `pkg-config gobject-2.0 gthread-2.0 gmodule-2.0 --libs` $^ -o $@

gomx-mp3-player.c: gomx-mp3-player.vala omx.vapi gomx.vapi
	valac $^ --thread $(VALAFLAGS)
	touch $@


libgstgomx.so: gstgomx.o gomx.o
	$(CC) -shared -fPIC `pkg-config gstreamer-0.10 --libs` $^ -o $@


gstgomx.c: gstgomx.vala gomx.vapi omx.vapi
	valac $^ $(VALAFLAGS) -D BELLAGIO
	touch $@


gomx.vapi: gomx.c

gomx.c: gomx.vala omx.vapi
	valac $^ --vapi=gomx.vapi -H gomx.h $(VALAFLAGS)
	touch $@


clean:
	rm -f *.o *.c *~ gomx-mp3-player libgstgomx.so gomx.vapi gomx.h
