pewpew="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
echo $pewpew

git --git-dir=$pewpew/.git fetch --all
git checkout -- $pewpew/
git --git-dir=$pewpew/.git reset --hard origin/master
