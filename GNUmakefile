MANAGED= \
				 .gitconfig \
				 .gitignore \
				 .config/git \
				 .vimrc \
				 .vim		\
				 .xmodmap \
				 .xprofile \
				 .xsessionrc \
				 .Xresources \
				 .zshrc \
				 .i3/config \
				 .ssh/config \
				 .ssh/profile \
				 .ssh/authorized_keys \
				 .config/fish \

all: submodules link

submodules:
	git submodule init
	git submodule sync
	git submodule update

submodules-update: submodules
	git submodule foreach git pull --ff-only origin master

link: $(MANAGED:%=$(HOME)/%)

$(HOME)/.% $(HOME)/%: %
	mkdir -p $(dir $@)
	ln -fs $(CURDIR)/$< $@

.PHONY: all submodules submodules-update link
