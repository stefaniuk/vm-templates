OS := ubuntu
VER := 16.04

BOX_PROVIDER := virtualbox
BOX_NAME := $(OS)
BOX_VER := $(VER).$(shell date +%Y%m%d)

help: ## Display help
	grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build:
	packer build \
		-var apt_proxy=$(APT_PROXY) \
		-var apt_proxy_ssl=${APT_PROXY_SSL} \
		-var version=$(BOX_VER) \
		$(OS)-$(VER)/template.json
test:
	vagrant box add \
		artifacts/$(BOX_NAME)-$(BOX_VER)-$(BOX_PROVIDER).box \
		--name $(BOX_NAME) \
		--force
	mkdir -p artifacts/test-$(BOX_NAME)-$(BOX_VER)
	cd artifacts/test-$(BOX_NAME)-$(BOX_VER); \
		vagrant init $(BOX_NAME); \
		vagrant up; \
		vagrant ssh; \
		vagrant halt; \
		vagrant destroy -f
	rm -rf artifacts/test-$(BOX_NAME)-$(BOX_VER)
clean:
	rm -rf artifacts/test-*
	rm -rf artifacts/*.box
	rm -rf output-*
	rm -rf packer_cache

.SILENT:
