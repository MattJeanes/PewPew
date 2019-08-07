pewpew=$(pwd)/.git

git --git-dir=$pewpew fetch --all
git --git-dir=$pewpew reset --hard origin/master
