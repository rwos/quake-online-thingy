EMCC_VERSION=1.37.22
EMCC_PATH=$(shell pwd)/emsdk-portable/emscripten/$(EMCC_VERSION)

init: submodules emsdk-portable/emsdk deps

all:
	$(MAKE) build

build:
	$(EMCC_PATH)/emcc -v
	$(EMCC_PATH)/emcc --clear-cache
	# build wants a normal .git dir
	mv quakejs/ioq3/.git quakejs/ioq3/.git_bak
	ln -s .git/modules/quakejs/modules/ioq3 quakejs/ioq3/.git
	$(MAKE) -C quakejs/ioq3 PLATFORM=js EMSCRIPTEN=$(EMCC_PATH)
	rm quakejs/ioq3/.git
	mv quakejs/ioq3/.git_bak quakejs/ioq3/.git
	cd quakejs && yarn

submodules:
	git submodule deinit --all -f
	git submodule sync
	git submodule update --init --recursive
	git submodule update --remote --merge

deps:
	./emsdk-portable/emsdk update
	./emsdk-portable/emsdk install sdk-$(EMCC_VERSION)-64bit
	./emsdk-portable/emsdk activate sdk-$(EMCC_VERSION)-64bit

# https://kripken.github.io/emscripten-site/docs/getting_started/downloads.html#platform-notes-installation-instructions-sdk
emsdk-portable/emsdk:
	wget https://s3.amazonaws.com/mozilla-games/emscripten/releases/emsdk-portable.tar.gz
	tar -xvzf emsdk-portable.tar.gz
	curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
	echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
	apt-get update -y
	apt-get install git build-essential cmake python2.7 nodejs default-jre yarn

apache-proxy-deps:
	a2enmod proxy
	a2enmod proxy_http
	a2enmod proxy_ajp
	a2enmod rewrite
	a2enmod deflate
	a2enmod headers
	a2enmod proxy_balancer
	a2enmod proxy_connect
	a2enmod proxy_html
	cp quake.conf /etc/apache2/sites-available/
	ln -s /etc/apache2/sites-available/quake.conf /etc/apache2/sites-enabled/quake.conf
	systemctl restart apache2
