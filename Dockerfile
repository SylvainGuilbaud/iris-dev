ARG IMAGE=containers.intersystems.com/intersystems/irishealth-community:latest-em
ARG IMAGE=containers.intersystems.com/intersystems/iris-community:latest-em

FROM $IMAGE

USER root

RUN apt-get update && apt-get install -y \
	sudo && \
	/bin/echo -e ${ISC_PACKAGE_MGRUSER}\\tALL=\(ALL\)\\tNOPASSWD: ALL >> /etc/sudoers && \
	sudo -u ${ISC_PACKAGE_MGRUSER} sudo echo enabled passwordless sudo-ing for ${ISC_PACKAGE_MGRUSER} 

ENV EXTERNAL_DATA_DIRECTORY=/volumes/IRIS
RUN mkdir -p $EXTERNAL_DATA_DIRECTORY && chown -R ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_MGRUSER} $EXTERNAL_DATA_DIRECTORY

USER ${ISC_PACKAGE_MGRUSER}  
COPY .iris_init /home/irisowner/.iris_init

WORKDIR /home/irisowner/dev

RUN --mount=type=bind,src=.,dst=. \
    iris start IRIS && \
    iris merge IRIS merge-build.cpf && \
	iris session IRIS < iris.script && \
    iris stop IRIS quietly 