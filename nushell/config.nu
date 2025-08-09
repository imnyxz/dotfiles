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

