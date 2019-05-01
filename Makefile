###
###
###

ifneq ($(shell grep -i "fedora\|red hat\|cent" /etc/issue),)
	INSTALL=yum install python-libs pyhton-devel cmake gcc-c++ wmctrl git clang clang-devel ctags-etags
else ifneq ($(shell grep -i "debian\|ubuntu\|mint" /etc/issue),)
	INSTALL=apt-get install build-essential cmake python-dev clang-3.4 libclang-3.4-dev wmctrl git
endif

DOTSBKP=~/.dotsbkp-$(shell date +"%Y-%m-%d")

clean:
	@echo Cleaning
	rm -rf bundle/*

backup:
	@echo Making backup at $(DOTSBKP)
	mkdir $(DOTSBKP)
	mv ~/.vim $(DOTSBKP)/
	mv ~/.vimrc $(DOTSBKP)/
	-mv ~/.viminfo $(DOTSBKP)/
	-mv ~/.vimtags $(DOTSBKP)/

deploy: install-deps link install-bundles fonts

link:
	@echo Linking dotfiles
	@if [ -L ~/.vimrc ]; then \
	unlink ~/.vimrc; \
	fi
	@if [ -L ~/config/nvim/init.vim ]; then \
	unlink ~/config/nvim/init.vim; \
	fi
	cd ~/ && ln -s ~/.vim/.vimrc .vimrc && ln -s ~/config/nvim/init.vim .vimrc

install-bundles:
	@echo Installing bundles...
	vim +PlugInstall +qall
	nvim +PlugInstall +qall

install-deps:
	@echo Installing dependencies...
	ifeq ($(INSTALL),)
	@echo Unknown OS.
	else
	sudo $(INSTALL)
	endif

fonts:
	@eczho Copying fonts...
	# -mkdir ~/.fonts
	# cp -r fonts/ ~/.fonts

.PHONY: clean deploy link install-bundles install-deps fonts
