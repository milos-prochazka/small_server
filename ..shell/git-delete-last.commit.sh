BRANCH="master"

read -p "HARD pro smazani dat, SOFT smaze jen commit:" commit

if [[ "$commit" == "SOFT" ]] ; then
   echo "SOFT"
   git reset --soft HEAD^
   git push origin $BRANCH --force
fi

if [[ "$commit" == "HARD" ]] ; then
   echo "HARD"
   git reset --hard HEAD^
   git push origin $BRANCH --force
fi

