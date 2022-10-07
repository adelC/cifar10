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

docker-proxy:
ifneq ($(HTTP_PROXY),)
	@sudo mkdir -p /etc/systemd/system/docker.service.d
	@grep -q ${HTTP_PROXY} /etc/systemd/system/docker.service.d/http-proxy.conf > /dev/null 2>&1 || \
		sudo bash -c " \
		echo '[Service]' > /etc/systemd/system/docker.service.d/http-proxy.conf && \
		echo 'Environment=\"HTTP_PROXY=${HTTP_PROXY}\"' >> /etc/systemd/system/docker.service.d/http-proxy.conf && \
		echo 'Environment=\"HTTPS_PROXY=${HTTPS_PROXY}\"' >> /etc/systemd/system/docker.service.d/http-proxy.conf && \
		echo 'Environment=\"NO_PROXY=localhost,127.0.0.1\"' >> /etc/systemd/system/docker.service.d/http-proxy.conf && \
		systemctl daemon-reload && systemctl restart docker"
else
	@sudo bash -c "rm -rf /etc/systemd/system/docker.service.d/http-proxy.conf && \
		  systemctl daemon-reload && systemctl restart docker"
endif

docker-build: docker-proxy 
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

