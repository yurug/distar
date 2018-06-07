####################################
# 	Makefile - distar          #
#  	Copyright (C) 2018         #
# Yan Régis-Gianas, Étienne Marais #
####################################

.PHONY: all build clean doc

# import dependencies and compile
all: build 	

# compile files and prepare installation
build:
	jbuilder build @install
	ln -sf _build/default/src bin
	ln -sf bin/distar.exe distar

# generate doc
doc:
	jbuilder build @doc
	ln -sf _build/default/_doc/_html doc

# clean links and repositories
clean: 
	jbuilder clean
	rm -f bin doc distar