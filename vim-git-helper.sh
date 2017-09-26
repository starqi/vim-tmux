A=~
A_VIMRC=.vimrc
A_VIMFOLDER=~/.vim

B=~/manual-install/vim-tmux
B_VIMRC=.vimrc

if [ "$1" = "push" ]; then
    cp $A/$A_VIMRC $B/$B_VIMRC
    cp -r $A_VIMFOLDER/plugged/snipmate.vim/snippets $B
    cd $B
    git diff
elif [ "$1" = "pull" ]; then
    cd $B
    cp $B/$B_VIMRC $A/$A_VIMRC
    cp -r $B/snippets $A_VIMFOLDER/plugged/snipmate.vim
    # Run pull manually
else
    echo Invalid command
fi
