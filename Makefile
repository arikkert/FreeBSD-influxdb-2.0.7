#
# Only installing dependencies require root priv.
# influxdb itself does not.
#

VERSION=v2.0.7

all: run

influxdb:
	if [ ! -d influxdb ]; \
	then \
		git clone https://github.com/influxdata/influxdb.git --branch $(VERSION) --single-branch; \
	fi

/usr/local/bin/bash:
	sudo pkg install -y bash

/bin/bash: /usr/local/bin/bash
	sudo ln -s /usr/local/bin/bash /bin/bash

/usr/local/bin/gmake:
	sudo pkg install -y gmake

/usr/local/bin/cargo:
	sudo pkg install -y rust

build: influxdb /usr/local/bin/gmake /bin/bash /usr/local/bin/cargo
	cd influxdb; \
	gmake

clean:
	rm -rf influxdb

run: build
	@echo "URL: http://$$(hostname):8086 version $(VERSION)"
	influxdb/bin/freebsd/influxd
