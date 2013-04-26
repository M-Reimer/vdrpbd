# Makefile for vdrpbd.

DESTDIR=
PREFIX=/usr/local
MANDIR=$(PREFIX)/share/man
BINDIR=$(PREFIX)/sbin
CONFDIR=/etc
SYSTEMDUNITDIR=$(shell pkg-config --variable systemdsystemunitdir systemd 2>/dev/null)
VERSION=$(shell sed -rn 's/.*\$$VERSION = .(.+?).;$$/\1/p' vdrpbd)

.PHONY: all install uninstall clean dist

all: vdrpbd.1 vdrpbd.conf.5
vdrpbd.1: vdrpbd; pod2man $< $@
vdrpbd.conf.5: vdrpbd.conf.pod; pod2man $< $@

install: all
	mkdir -p $(DESTDIR)$(MANDIR)/man1
	gzip -c vdrpbd.1 > $(DESTDIR)$(MANDIR)/man1/vdrpbd.1.gz

	mkdir -p $(DESTDIR)$(MANDIR)/man5
	gzip -c vdrpbd.conf.5 > $(DESTDIR)$(MANDIR)/man5/vdrpbd.conf.5.gz

	mkdir -p $(DESTDIR)$(CONFDIR)
	cp -pn vdrpbd.conf $(DESTDIR)$(CONFDIR)

	install -D -m 755 vdrpbd $(DESTDIR)$(BINDIR)/vdrpbd

ifneq ($(strip $(SYSTEMDUNITDIR)),)
	install -D -m 644 vdrpbd.service $(DESTDIR)$(SYSTEMDUNITDIR)/vdrpbd.service
	sed -i "s#/usr/sbin/vdrpbd#$(BINDIR)/vdrpbd#" $(DESTDIR)$(SYSTEMDUNITDIR)/vdrpbd.service
endif

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/vdrpbd
	rm -f $(DESTDIR)$(MANDIR)/man1/vdrpbd.1.gz
	rm -f $(DESTDIR)$(MANDIR)/man5/vdrpbd.conf.5.gz
ifneq ($(strip $(SYSTEMDUNITDIR)),)
	rm -f $(DESTDIR)$(SYSTEMDUNITDIR)/vdrpbd.service
endif

clean:
	@rm -f vdrpbd.1
	@rm -f vdrpbd.conf.5
	@rm -f vdrpbd-*.tar.xz

dist: clean
	@tar --transform="s#^#vdrpbd-$(VERSION)/#" \
	--owner=0 --group=0 \
	-vcJf vdrpbd-$(VERSION).tar.xz *
	@echo "Distribution archive 'vdrpbd-$(VERSION).tar.xz' generated"
