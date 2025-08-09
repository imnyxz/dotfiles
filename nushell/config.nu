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

def "nu-complete jj bookmark names" [] {
  jj bookmark list -a --template 'name ++ "\n"' | str trim
}

  export extern "jj edit" [
    revision?: string@"nu-complete jj bookmark names"
    -r                        # Ignored (but lets you pass `-r` for consistency with other commands)
    --repository(-R): path    # Path to repository to operate on
    --ignore-working-copy     # Don't snapshot the working copy, and don't update it
    --ignore-immutable        # Allow rewriting immutable commits
    --at-operation: string    # Operation to load the repo at
    --at-op: string           # Operation to load the repo at
    --debug                   # Enable debug logging
    --color: string	      # When to colorize output
    --quiet                   # Silence non-primary command output
    --no-pager                # Disable the pager
    --config: string          # Additional configuration options (can be repeated)
    --config-toml: string     # Additional configuration options (can be repeated) (DEPRECATED)
    --config-file: path       # Additional configuration files (can be repeated)
    --help(-h)                # Print help (see more with '--help')
  ]

def run-hooks-for [stage: string, ...args] {
    git add -A
    
    let hook_patterns = {
        "commit": "pre-commit|prepare-commit-msg|commit-msg|post-commit",
        "push": "pre-push|post-push", 
        "merge": "pre-merge-commit|post-merge",
        "rebase": "pre-rebase|post-rewrite"
    }
    
    let pattern = $hook_patterns | get $stage
    let hooks = get-git-hooks | where $it =~ $pattern
    
    for hook in $hooks {
        let hooks_dir = (git rev-parse --git-dir) + "/.git/hooks"
        let hook_path = $hooks_dir + "/" + $hook
        
        print $"🔄 Running ($hook)..."
        ^$hook_path
        
        if $env.LAST_EXIT_CODE != 0 {
            print $"❌ ($hook) failed"
            return
        } else {
            print $"✅ ($hook) passed"
        }
    }
    
    # Return success so the calling function knows hooks passed
    true
}

def jjc [...args] {
    if (run-hooks-for "commit") {
        print "🚀 All hooks passed, committing..."
        ^jj commit -m ...$args
    }
}

def jjp [...args] {
    if (run-hooks-for "push") {
        print "🚀 All hooks passed, pushing..."
        ^jj push ...$args
    }
}
