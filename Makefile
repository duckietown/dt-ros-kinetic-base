
name=duckietown/rpi-ros-kinetic-base:master18

build:
	docker build -t $(name) .

push:
	docker push $(name)
