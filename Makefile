EMCC_VERSION=sdk-tag-1.28.2-64bit
EMCC_PATH=$(shell pwd)/emsdk-portable/emscripten/$(EMCC_VERSION)

init: submodules emsdk-portable/emsdk deps

all:
	$(MAKE) build

build:
	$(EMCC_PATH)/emcc -v
	# build wants a normal .git dir
	mv quakejs/ioq3/.git quakejs/ioq3/.git_bak
	ln -s .git/modules/quakejs/modules/ioq3 quakejs/ioq3/.git
	$(MAKE) -C quakejs/ioq3 PLATFORM=js EMSCRIPTEN=$(EMCC_PATH)
	rm quakejs/ioq3/.git
	mv quakejs/ioq3/.git_bak quakejs/ioq3/.git
	cd quakejs && npm install

submodules:
	git submodule deinit --all
	git submodule update --init --recursive

deps:
	./emsdk-portable/emsdk update
	./emsdk-portable/emsdk install $(EMCC_VERSION)
	./emsdk-portable/emsdk activate $(EMCC_VERSION)

# https://kripken.github.io/emscripten-site/docs/getting_started/downloads.html#platform-notes-installation-instructions-sdk
emsdk-portable/emsdk:
	wget https://s3.amazonaws.com/mozilla-games/emscripten/releases/emsdk-portable.tar.gz
	tar -xvzf emsdk-portable.tar.gz
	apt-get update -y
	apt-get install git build-essential cmake python2.7 nodejs default-jre
