VERSION?=$$(cat version.go | grep VERSION | cut -d"=" -f2 | sed 's/"//g')
GOFMT_FILES?=$$(find . -name '*.go')
PROJECT_BIN?=go-cli
PROJECT_SRC?=github.com/nicholasgasior/go-cli

default: build

guard-%:
	@ if [ "${${*}}" = "" ]; then \
		echo "Environment variable $* not set"; \
		exit 1; \
	fi

fmt:
	gofmt -w $(GOFMT_FILES)

fmtcheck:
	@ gofmt_files=$$(gofmt -l $(GOFMT_FILES)); \
	if [[ -n $${gofmt_files} ]]; then \
		echo "The following files fail gofmt:"; \
		echo "$${gofmt_files}"; \
		echo "Run \`make fmt\` to fix this."; \
		exit 1; \
	fi

test:
	go test


.NOTPARALLEL:

.PHONY: test fmt build
