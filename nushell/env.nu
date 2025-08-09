$env.PATH = ($env.PATH | append "/run/current-system/sw/bin" | append "/Users/offblck/.bun/bin" | append "/Users/offblck/.cargo/bin" )

try { source ~/dotfiles/nushell/secrets.nu }
