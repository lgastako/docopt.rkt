RACO=raco

APP=docopt

BINARY=./$(APP)

INSTALL_DIR=~/local/bin

all:
	@cat Makefile

$(BINARY): *.rkt
	$(RACO) exe -o docopt demo.rkt

build: $(BINARY)

clean:
	\rm -rf $(BINARY)

help: build
	$(BINARY) --help

help2:  # (no args should produce --help output)
	$(BINARY)

install: build
	cp $(BINARY) $(INSTALL_DIR)

b: build
h: help
h2: help2
i: install
