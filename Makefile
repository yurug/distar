
.PHONY: all build clean doc check

# Import dependencies and compile
all: build 	

# Compile files and prepare installation
build:
	jbuilder build @install
	ln -sf _build/install/default/bin bin

# Generate documentation
doc:
	jbuilder build @doc
	ln -sf _build/default/_doc/_html doc

# Launch tests
check:  
	@jbuilder build @runtest

# Clean links and repositories
clean: 
	jbuilder clean
	rm -f bin doc distar
