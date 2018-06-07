####################################
# 	Makefile - distar          #
#  	Copyright (C) 2018         #
# Yan Régis-Gianas, Étienne Marais #
####################################


.PHONY: all build clean doc

# importe les dépendances, compile et lance l'exécutable
all: build run	

# lance le programme
run:
	jbuilder exec distar

# compile les fichiers et prépare pour l'installation
build:
	jbuilder build @install
	ln -sf _build/default/src bin

# créer la documentation
doc:
	jbuilder build @doc
	ln -sf _build/default/_doc/_html doc

# nettoie le répertoire et les liens
clean: 
	jbuilder clean
	rm -f bin doc
