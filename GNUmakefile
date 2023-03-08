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
				 .zgen-setup \
				 .zsh_aliases \
				 .zsh_functions \
				 .zshrc.d \
				 .i3/config \
				 .ssh/config \
				 .ssh/profile \
				 .ssh/authorized_keys \
				 .config/fish \
				 .terraformrc \
				 .terraform.d/plugin-cache/.placeholder \

all: submodules link

submodules:
	git submodule init
	git submodule sync
	git submodule update

submodules-update: submodules
	git submodule foreach git pull --ff-only origin master

link: $(MANAGED:%=$(HOME)/%) directories

$(HOME)/.% $(HOME)/%: %
	mkdir -p $(dir $@)
	ln -fs $(CURDIR)/$< $@

.PHONY: all submodules submodules-update link directories
