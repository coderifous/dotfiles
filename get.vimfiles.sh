# Downloads dotfiles repository to current directory, then links vim dot-files
# into current user's home directory.
#
# Requires git.
#
# Easy run:
#
#   curl https://raw.github.com/coderifous/dotfiles/master/get.vimfiles.sh | sh

REPO_NAME="dotfiles"
# Replace the hostname, username and repository name as required to use your
# own fork instead of Coderifous's.
GIT_REPO_URL="git@github.com:coderifous/$REPO_NAME.git"

echo -e "\033[32mDownloading repository."
echo -e "\033[0m"

git clone $GIT_REPO_URL

echo
echo -e "\033[32mUpdating submodules."
echo -e "\033[0m"
echo "REPO_NAME = $REPO_NAME"
cd $REPO_NAME
git submodule update --init

backup_file() {
  if [ -e $1 ] || [ -L $1 ];
  then
    bakext=".bak"
    bakfile=$1$bakext
    echo -e "\033[32mBacking up \"$1\" to \"$bakfile\"."
    echo -e "\033[0m"
    mv $1 $bakfile
  fi
}

echo
echo -e "\033[32mCreating dotfile links in home dir."
echo -e "\033[0m"

VIMHOME=`pwd`"/vim"

backup_file ~/.vim
ln -s $VIMHOME ~/.vim

backup_file ~/.vimrc
ln -s ~/.vim/vimrc ~/.vimrc

backup_file ~/.gvimrc
ln -s ~/.vim/gvimrc ~/.gvimrc


if [ ! -d ~/.vim_tmp ];
then
  echo
  echo -e "\033[32mCreating ~/.vim_tmp: where vim is configured to store temporary files."
  echo -e "\033[0m"
  mkdir ~/.vim_tmp
fi

#end

echo
echo -e "\033[32mVim dotfiles installed!"
echo -e "\033[0m"
