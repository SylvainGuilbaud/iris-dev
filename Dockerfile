ARG IMAGE=containers.intersystems.com/intersystems/irishealth-community:latest-em
FROM $IMAGE

USER ${ISC_PACKAGE_MGRUSER}  
COPY .iris_init /home/irisowner/.iris_init

WORKDIR /home/irisowner/dev

RUN --mount=type=bind,src=.,dst=. \
    iris start IRIS && \
    iris merge IRIS merge.cpf && \
	iris session IRIS < iris.script && \
    iris stop IRIS quietly 