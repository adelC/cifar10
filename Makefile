#----------------------------------------------------------------------------------------------------------------------
# Flags
#----------------------------------------------------------------------------------------------------------------------
SHELL:=/bin/bash

export TERM=xterm


export DOCKER_IMAGE_NAME?=cifar10_image
#----------------------------------------------------------------------------------------------------------------------
# Targets
#----------------------------------------------------------------------------------------------------------------------
default:  

docker-build: 
	@$(call msg, Building docker image ${DOCKER_IMAGE_NAME} ...)
	@docker build -t ${DOCKER_IMAGE_NAME} .

docker-run: docker-build
	@$(call msg, Running docker container for ${DOCKER_IMAGE_NAME} image  ...)
	@docker run -it --rm -a stdout -a stderr --privileged -v /dev:/dev  ${DOCKER_IMAGE_NAME}  


#----------------------------------------------------------------------------------------------------------------------
# helper functions
#----------------------------------------------------------------------------------------------------------------------
define msg
	tput setaf 2 && \
	for i in $(shell seq 1 120 ); do echo -n "-"; done; echo  "" && \
	echo "         "$1 && \
	for i in $(shell seq 1 120 ); do echo -n "-"; done; echo "" && \
	tput sgr0
endef

