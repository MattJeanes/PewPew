pewpew="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/.git"
echo $pewpew
echo $pewpew
echo $pewpew

git --git-dir=$pewpew fetch --all
git --git-dir=$pewpew reset --hard origin/master
