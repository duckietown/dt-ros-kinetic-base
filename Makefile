
ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))

build_mk=$(ROOT_DIR)/docker-tools/build.mk

env_check:
	@# check if the docker-tools repo is initialized
	@if [ ! -f "$(build_mk)" ]; then \
		git submodule init; \
		git submodule update; \
	fi

build build-no-cache push: env_check
	$(MAKE) -f $(build_mk) _$@
