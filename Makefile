#
# Only installing dependencies require root priv.
# influxdb itself does not.
#

VERSION=v2.0.7
DISTDIR=influxdb

all: run

$(DISTDIR):
	if [ ! -d $(DISTDIR) ]; \
	then \
		git clone https://github.com/influxdata/$(DISTDIR).git --branch $(VERSION) --single-branch; \
	fi

/usr/local/bin/bash:
	sudo pkg install -y bash

/bin/bash: /usr/local/bin/bash
	sudo ln -s /usr/local/bin/bash /bin/bash

/usr/local/bin/gmake:
	sudo pkg install -y gmake

/usr/local/bin/cargo:
	sudo pkg install -y rust

build: $(DISTDIR) /usr/local/bin/gmake /bin/bash /usr/local/bin/cargo
	cd $(DISTDIR); \
	gmake

distclean:
	rm -rf $(DISTDIR)

clean: distclean

removedb:
	rm -rf $(HOME)/.influxdbv2

run: build
	@echo "URL: http://$$(hostname):8086"
	$(DISTDIR)/bin/freebsd/influxd version
	$(DISTDIR)/bin/freebsd/influxd
