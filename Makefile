OS := ubuntu
OS_VER := 16.04
OS_TYPE := server
BOX_PROVIDER := virtualbox

help:
	echo
	echo "Usage:"
	echo
	echo "    make build|test [OS=name] [OS_VER=version] [OS_TYPE=server|desktop] [APT_PROXY=ip:port]"
	echo "    make clean"
	echo

build:
	packer build \
		-var apt_proxy=$(APT_PROXY) \
		-var apt_proxy_ssl=$(APT_PROXY_SSL) \
		-var os_version=$(OS_VER) \
		-var os_type=$(OS_TYPE) \
		-var version=$(shell cat VERSION) \
		-var build_script_desktop=$(shell echo $(OS_TYPE) | grep desktop > /dev/null 2>&1 && echo yes || echo no) \
		$(OS)-$(OS_VER)/template.json
test:
	vagrant box add \
		artifacts/$(OS)-$(OS_VER)-$(OS_TYPE)-$(shell cat VERSION)-$(BOX_PROVIDER).box \
		--name $(OS) \
		--force
	mkdir -p artifacts/test-$(OS)-$(OS_VER)
	cd artifacts/test-$(OS)-$(OS_VER); \
		vagrant init $(OS); \
		vagrant up; \
		vagrant ssh; \
		vagrant halt
clean:
	cd $(shell ls -d artifacts/test-*) && vagrant destroy -f
	rm -rf artifacts/test-*
	rm -rf artifacts/*.box
	rm -rf output-*
purge: clean
	rm -rf packer_cache

.SILENT:
