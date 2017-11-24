init: submodules deps

all:
	$(MAKE) build

build:
	$(MAKE) -C quakejs/ioq3 PLATFORM=js EMSCRIPTEN=$(shell pws)/emsdk-portable/emcc ### XXX ??? probably wrong
	cd quakejs && npm install

submodules:
	git submodule update --init --recursive

deps: emsdk-portable/emsdk
	./emsdk-portable/emsdk update
	./emsdk-portable/emsdk install latest
	./emsdk-portable/emsdk activate latest

# https://kripken.github.io/emscripten-site/docs/getting_started/downloads.html#platform-notes-installation-instructions-sdk
emsdk-portable/emsdk:
	wget https://s3.amazonaws.com/mozilla-games/emscripten/releases/emsdk-portable.tar.gz
	tar -xvzf emsdk-portable.tar.gz
	apt-get update -y
	apt-get install git build-essential cmake python2.7 nodejs default-jre
