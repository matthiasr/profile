all: submodules link

submodules:
	git submodule init
	git submodule sync
	git submodule update

link: ../.vimrc

../.vimrc: vimrc
	ln -s .vim/vimrc ../.vimrc

.PHONY: all submodules link
