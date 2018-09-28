branch=$(shell git rev-parse --abbrev-ref HEAD)

name=duckietown/rpi-ros-kinetic-base:$(branch)

build:
	docker build -t $(name) .

push:
	docker push $(name)
