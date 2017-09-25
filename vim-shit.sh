# Change paths
A=/c/Users/ewang/AppData/Local/nvim
AFile=init.vim
B=~/vim-tmux
BFile=.vimrc

if [ "$1" = "push" ]; then
	cp $A/$AFile $B/$BFile
	cd $B
	git diff
elif [ "$1" = "pull" ]; then
	cd $B
	cp $B/$BFile $A/$AFile
	# Run pull manually
else
	echo Invalid command
fi
