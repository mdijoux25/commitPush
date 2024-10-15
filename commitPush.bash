#!/bin/bash
function commitpush() {
    if [ "$1" = "" ]; then
    echo -e "🔥Usage: commit \"Un message de commit\"🔥"
    exit
    fi
    echo "🔰 Lancement du commit et du push...."
    if [ -z "$(git status --porcelain)" ]; then
      echo "🔴 Pas de changement à commit."
      exit 0
    fi
    currentbranch=$(git branch | grep "*" | cut -b 3-)
    echo "✅ Changement à apporter: "
    git status --porcelain
    echo ====================================
    echo Branche actuelle : $currentbranch.
    echo ====================================
    commitmsg=\'"$@"\'
    echo "push-t-on dans la branche ➡ $currentbranch (Y/N) ?"
    read yn
    if [ "$yn" = y ]; then
        git add -A
        git commit -am "$commitmsg"
        git push origin "$currentbranch"
        echo "🚀🚀 push fait dans la branche $currentbranch 🚀🚀"
        commitid=$(git rev-parse HEAD)
        echo "🔗🔗lien : https://github.com/{nomdurepos}/$(basename `git rev-parse --show-toplevel`)/commit/$commitid"
    else
        echo "Abandon du commit/push 😥!"
        exit 0
    fi
}

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "Erreur: le dossier actuel n'est pas un repos Git."
  exit 1
fi

commitpush $1