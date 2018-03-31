.PHONY: secrets data

SECRETS_BASEDIR ?= secrets
DATA_BASEDIR ?= data

all:

secrets:
	mkdir -p $(SECRETS_BASEDIR)/wflowserver
	yes|ssh-keygen -f $(SECRETS_BASEDIR)/wflowserver/id_rsa -t rsa -N ''
	
	mkdir -p $(SECRETS_BASEDIR)/yadagesvc
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $(SECRETS_BASEDIR)/yadagesvc/ssl.key -out $(SECRETS_BASEDIR)/yadagesvc/ssl.crt -subj "/CN=yadagesvc/O=yadagesvc"

	mkdir -p $(SECRETS_BASEDIR)/controlcenter
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $(SECRETS_BASEDIR)/controlcenter/ssl.key -out $(SECRETS_BASEDIR)/controlcenter/ssl.crt -subj "/CN=recastcc/O=recastcc"
	
	mkdir -p $(SECRETS_BASEDIR)/frontend
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout $(SECRETS_BASEDIR)/frontend/ssl.key -out $(SECRETS_BASEDIR)/frontend/ssl.crt -subj "/CN=recastfrontend/O=recastfrontend"

data:
	mkdir -p $(DATA_BASEDIR)/controlcenter
	mkdir -p $(DATA_BASEDIR)/frontend
	mkdir -p $(DATA_BASEDIR)/worker
	mkdir -p $(DATA_BASEDIR)/infra
	mkdir -p $(DATA_BASEDIR)/wflowserver
	mkdir -p $(DATA_BASEDIR)/yadagesvc
