.DEFAULT_GOAL := build

license:
	curl -sL https://liam.sh/-/gh/g/license-header.sh | bash -s

fetch:
	go mod tidy
	cd ./examples/kitchensink && go mod tidy
	cd ./lemm && go mod tidy
	cd ./stem && go mod tidy

up:
	go get -u ./... && go get -u -t ./... && go mod tidy
	cd ./examples/kitchensink && go get -u ./... && go get -u -t ./... && go mod tidy
	cd ./lemm && go get -u ./... && go get -u -t ./... && go mod tidy
	cd ./stem && go get -u ./... && go get -u -t ./... && go mod tidy

prepare: fetch
	go generate -x ./...

test: prepare
	go test -v -count=10 ./...
	cd ./examples/kitchensink && go test -v -count=10 ./...

update-snapshots: prepare
	cd ./examples/kitchensink && UPDATE_SNAPS=true go test -v -count=10 ./...
