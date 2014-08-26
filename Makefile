all: submodules link

submodules:
	git submodule init
	git submodule sync
	git submodule update

submodules-update: submodules
	git submodule foreach git pull --ff-only origin master

link: $(HOME)/.vimrc $(HOME)/.vim $(HOME)/.zshrc $(HOME)/.i3/config

$(HOME)/.%: %
	mkdir -p $(dir $@)
	ln -fs $(CURDIR)/$< $@

.PHONY: all submodules submodules-update link
