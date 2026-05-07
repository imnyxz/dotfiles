$env.config = {
	shell_integration: {
	 osc2: true
	 osc7: true
	 osc8: true
	 osc9_9: false
	 osc133: true
	 osc633: true
	 reset_application_mode: true
	},
	buffer_editor: "nvim"
}
$env.EDITOR = "zeditor"

def git-commit-dated [
    message: string,  # Commit message
    time: string      # Time in format "HH:MM:SS"
    date?: string     # Optional date in format "YYYY-MM-DD"
] {
    let date_str = if ($date | is-empty) {
        (date now | format date "%Y-%m-%d")
    } else {
        $date
    }
    let datetime = $"($date_str) ($time)"
    with-env {
        GIT_AUTHOR_DATE: $datetime
        GIT_COMMITTER_DATE: $datetime
    } {
        git commit -m $message
    }
}

def git-clean-branches [
    --dry-run (-n)   # just preview what would be deleted
    --keep (-k): list<string> = []  # branches to keep
] {
    git fetch --prune

    let gone_branches = (git branch -vv
        | lines
        | where $it =~ ': gone]'
        | parse "{flag} {branch} *"
        | get branch)

    if ($gone_branches | is-empty) {
        print "✅ No branches to delete."
        return
    }

    for b in $gone_branches {
        if ($keep | any {|k| $k == $b}) {
            print $"⏩ Keeping ($b)"
        } else if $dry_run {
            print $"Would delete ($b)"
        } else {
            print $"🗑️ Deleting ($b)"
            git branch -D $b | ignore
        }
    }
}

alias gcd = git-commit-dated
alias gcb = git-clean-branches
alias g = git
