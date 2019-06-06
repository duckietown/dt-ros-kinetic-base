# DO NOT MODIFY - it is auto written from duckietown-env-developer

default_arch=arm32v7
arch=$(default_arch)

branch=$(shell git rev-parse --abbrev-ref HEAD)

# name of the repo
repo=$(shell basename -s .git `git config --get remote.origin.url`)

ifeq ($(arch), $(default_arch))
	tags=duckietown/$(repo):$(branch)-$(arch) duckietown/$(repo):$(branch)
else
	tags=duckietown/$(repo):$(branch)-$(arch)
endif

labels=$(shell ./labels.py)

build: no_cache=0
build-no-cache: no_cache=1

build build-no-cache:
	@- $(foreach tag,$(tags), \
		docker build \
			--pull \
			$(labels) \
			-t $(tag) \
			--build-arg ARCH=$(arch) \
			--no-cache=$(no_cache) \
			.; \
  )

push:
	@- $(foreach tag,$(tags), \
		docker push $(tag); \
  )
