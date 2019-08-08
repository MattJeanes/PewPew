pewpew="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

cd $pewpew

git checkout . &&
git pull origin master
