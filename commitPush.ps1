function commitpush {
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$commitMsg
    )
    git rev-parse --is-inside-work-tree *>$null
 
    if ($LastExitCode -ne 0) {
        Write-Host "🔥Erreur: le dossier actuel n'est pas un repos Git.🔥"
        return
    }

    if ($null -eq $commitMsg) {
        Write-Host "Usage: commitpush -commitMsg 'Un message de commit'";
        return;
    }
    else {
        Write-Host "🔰 Lancement du commit et du push...."
        if ($(git status --porcelain) -ne $null) {
            $currentBranch = git rev-parse --abbrev-ref HEAD
            Write-Host "✅ Changement à apporter:"
            git status --porcelain
            Write-Host "==========================="
            Write-Host "⭐--Branche actuelle : $currentBranch.--⭐"
            Write-Host "==========================="
            Write-Host "⚡--push-t-on dans la branche 👉 $currentBranch (Y/N) ?--⚡"
            $response = Read-Host "Yes/No"
            if ($response -eq "y") {
                git add -A
                git commit -am "$commitMsg"
                git push origin $currentBranch
                Write-Host "🚀🚀 push fait dans la branche $currentBranch 🚀🚀"
                $commitid = git rev-parse HEAD
                $repo = git config --get remote.origin.url
                Write-Host "🔗🔗lien : $repo/commit/$commitid"
            }
            else {
                "Abandon du commit/push 😥!"
                return
            }
        }
        else {
            Write-Host "🔴 Pas de changement à commiter."
            return
        }      
    }
}