all: submodules link

submodules:
	git submodule init
	git submodule sync
	git submodule update

submodules-update: submodules
	git submodule foreach git pull --ff-only origin master

link: ../.vimrc

link: $(HOME)/.vimrc $(HOME)/.vim $(HOME)/.zshrc

$(HOME)/.vimrc: vim/vimrc
	ln -s $(CURDIR)/vim/vimrc $@

$(HOME)/.vim: vim
	ln -s $(CURDIR)/vim $@

$(HOME)/.zshrc: zshrc
	ln -s $(CURDIR)/zshrc $@

.PHONY: all submodules submodules-update link
