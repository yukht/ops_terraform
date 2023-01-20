#!/bin/bash
read -p "Please make sure you read the listing of this script before installing vim-polyglot. To continue write \"Yes\": " input_yes
if [ -z $input_yes ] || [ $input_yes != 'Yes' ]
then
	exit 1
else
	mkdir -p ~/.vim/autoload ~/.vim/bundle && \
	git clone https://github.com/tpope/vim-pathogen && cp -r vim-pathogen/autoload/* ~/.vim/autoload/ && \
	printf "execute pathogen#infect()\nsyntax on\nfiletype plugin indent on\n" >> ~/.vimrc && \
	git clone https://github.com/sheerun/vim-polyglot && mv vim-polyglot ~/.vim/bundle/ && \
	rm -fr vim-pathogen && \
	printf "\n	Installation complete! Check .tf files in your VIM.\n
	How to enable other programming languages you can look at the page https://github.com/sheerun/vim-polyglot\n"
fi

