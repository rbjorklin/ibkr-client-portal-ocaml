# Build
PROFILE ?= dev
ALPINE_VERSION ?= 3.19
DOCKER = $(shell bash -c 'basename $$(which podman 2> /dev/null) 2> /dev/null || echo docker')
SELINUX = $(shell bash -c '( [ "$$(getenforce)" = "Enforcing" ] && echo -n ":z") || echo -n ""')
TAG = $(shell git describe --abbrev=0 --tags 2> /dev/null || git rev-parse --short=7 HEAD)
COMPILER_VERSION ?= 5.1.1
COMPILER_IMAGE ?= rbjorklin/ocaml-build
COMPILER_IMAGE_TAG = $(ALPINE_VERSION)-$(COMPILER_VERSION)

.PHONY: deps coverage clean build test

deps:
	opam install --yes --deps-only .

coverage:
	opam exec -- dune runtest --instrument-with bisect_ppx --force || true
	@opam exec -- bisect-ppx-report html
	@opam exec -- bisect-ppx-report cobertura cobertura.xml
	opam exec -- bisect-ppx-report summary --per-file

clean:
	rm -rf _build

build:
	@# Using '@install' is highly recommended as otherwise all files in the directory
	@# will be copied into the build directory. https://dune.readthedocs.io/en/stable/usage.html#built-in-aliases
	opam exec -- dune build --profile $(PROFILE) @install

test:
	opam exec -- dune runtest

docker-%:
	$(DOCKER) run --rm -ti --volume $(PWD):/build$(SELINUX) --workdir /build $(COMPILER_IMAGE):$(COMPILER_IMAGE_TAG) make $* PROFILE=$(PROFILE)
