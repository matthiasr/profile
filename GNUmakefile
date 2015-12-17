MANAGED= \
				 .gitconfig \
				 .gitignore \
				 .vimrc \
				 .vim		\
				 .zshrc \
				 .i3/config \
				 .ssh/config \
				 .ssh/profile \
				 .ssh/authorized_keys

all: submodules link install

submodules: install
	git submodule init
	git submodule sync
	git submodule update

submodules-update: submodules
	git submodule foreach git pull --ff-only origin master

link: $(MANAGED:%=$(HOME)/%)

install:
	sh ./install.sh sudo vim zsh mosh git

$(HOME)/.%: %
	mkdir -p $(dir $@)
	ln -fs $(CURDIR)/$< $@

.PHONY: all submodules submodules-update link install
