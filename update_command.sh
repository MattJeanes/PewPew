pewpew="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )/.git"

git --git-dir=$pewpew fetch --all
git --git-dir=$pewpew reset --hard origin/master
