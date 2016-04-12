HEKA_DEB = heka_0.10.0_amd64.deb

PWD = $(shell pwd)

.PHONY: download-heka
download-heka: .build/$(HEKA_DEB)

.PHONY: build-heka
build-heka: download-heka Dockerfile
	docker build -t elemoine/heka .

.PHONY: heka-producer
heka-producer:
	docker run -it --rm --name="$@" -v $(PWD)/heka-config/:/heka-config/ elemoine/heka -config=/heka-config/$@.toml

.PHONY: heka-flood
heka-flood:
	docker exec -it heka-producer heka-flood -config=/heka-config/$@.toml -test="default"

.PHONY: heka-producer-stats
heka-producer-stats:
	docker stats heka-producer

.build/$(HEKA_DEB):
	mkdir -p $(dir $@)
	wget -O $@ https://github.com/mozilla-services/heka/releases/download/v0.10.0/heka_0.10.0_amd64.deb

.PHONY: cleanall
cleanall: clean
	rm -rf .build
