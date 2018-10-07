
.PHONY: all build clean doc check

# Import dependencies and compile
all: build 	

# Compile files and prepare installation
build:
	dune build @install
	ln -sf _build/install/default/bin bin

# Generate documentation
doc:
	dune build @doc
	ln -sf _build/default/_doc/_html doc

# Launch tests
check: clean build 
	@dune build @runtest

# Clean links and repositories
clean: 
	dune clean
	rm -f bin doc distar
