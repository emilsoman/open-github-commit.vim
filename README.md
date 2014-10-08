open-github-commit.vim
======================

Adds the following commands :

`:OpenGithubCommit` opens the last git commit of current line on github. 
`:OpenGithubPR` opens the PR which got merged containing the last git commit of current line.

To map your custom shortcut, add this to your vimrc.

    map <silent> SHORTCUT :OpenGithubCommit<CR>

Replace `SHORTCUT` with your keyboard shortcut.

## Installation

This plugin follows the standard runtime path structure, and as such it can be installed with a variety of plugin managers:

*  Pathogen
  *  `git clone https://github.com/emilsoman/open-github-commit.vim ~/.vim/bundle/open-github-commit.vim`
*  NeoBundle
  *  `NeoBundle 'emilsoman/open-github-commit.vim'`
*  Vundle
  *  `Plugin 'emilsoman/open-github-commit.vim'`
*  VAM
  *  `call vam#ActivateAddons([ 'open-github-commit.vim' ])`
*  manual
  *  copy all of the files into your `~/.vim` directory


## License

MIT License. Copyright (c) 2014 Emil Soman
