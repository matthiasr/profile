all: submodules link

submodules:
	git submodule init
	git submodule sync
	git submodule update

link: $(HOME)/.vimrc $(HOME)/.vim

$(HOME)/.vimrc: vim/vimrc
	ln -s $(CURDIR)/vim/vimrc $@

$(HOME)/.vim: vim
	ln -s $(CURDIR)/vim $@

.PHONY: all submodules link
