all: submodules link

submodules:
	git submodule init
	git submodule sync
	git submodule update

submodules-update: submodules
	git submodule foreach git pull --ff-only origin master

link: $(HOME)/.vimrc $(HOME)/.vim $(HOME)/.zshrc

$(HOME)/.vimrc: vim/vimrc
	ln -fs $(CURDIR)/vim/vimrc $@

$(HOME)/.vim: vim
	ln -fs $(CURDIR)/vim $@

$(HOME)/.zshrc: zshrc
	ln -fs $(CURDIR)/zshrc $@

.PHONY: all submodules submodules-update link
