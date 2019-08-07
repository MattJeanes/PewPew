pewpew="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd $pewpew

git fetch --all &&
git checkout -- $pewpew &&
git reset --hard origin/master
