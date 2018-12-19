NAME=qqbot
VERSION=$(shell cat setup.py | grep version | head -1 | sed -e "s/.*'v\(.*\)'.*/\1/")
SHORTVERSION=$(shell echo ${VERSION} | sed -e 's/^\(.*\..*\)\..*/\1/')
REGISTRY_PREFIX=$(if $(REGISTRY),$(addsuffix /, $(REGISTRY)))

.PHONY: build publish update rollback create

build:
	docker build --build-arg version=${VERSION} \
		-t ${NAME}:${VERSION} .

publish:
	docker tag ${NAME}:${VERSION} ${REGISTRY_PREFIX}${NAME}:${VERSION}
	docker push ${REGISTRY_PREFIX}${NAME}:${VERSION}

update:
	docker service update --image ${NAME}:${VERSION} ${NAME}

rollback:
	docker service rollback ${NAME}

create:
	docker service create --replicas 1 -p 8188:8188 -p 8189:8189 \
		--env "HOST={{.Node.Hostname}}" \
		--env "TERM_HOST=0.0.0.0" \
		--mount source=qqbot-tmp,destination=/home/qqbot/.qqbot-tmp \
		--config source=qqbot.v${SHORTVERSION}.conf,target=/home/qqbot/.qqbot-tmp/v${SHORTVERSION}.conf,mode=0444 \
		--name ${NAME} ${REGISTRY_PREFIX}${NAME}:${VERSION}
