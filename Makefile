######################################
#       Makefile - distar            #
#  	Copyright (C) 2018           #
# Yann Régis-Gianas - Étienne Marais #
######################################

.PHONY: all build clean doc

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
	@make clean 1> /dev/null

# Clean links and repositories
clean: 
	jbuilder clean
	rm -f bin doc distar
