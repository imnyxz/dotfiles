$env.PATH = ( $env.PATH 
  | append "/run/current-system/sw/bin" 
  | append "/Users/offblck/.bun/bin" 
  | append "/Users/offblck/.cargo/bin" 
  | append "/Users/offblck/personal/zig-x86_64-macos-0.15.1" 
  | append "/opt/homebrew/bin" 
  | append "/opt/homebrew/opt/postgresql@16/bin"
  | append "/Users/offblck/.local/bin")

for key in [szuhaydv nyxz] {
    if (ssh-add -l | grep $key | is-empty) == false {
        # Key already loaded, do nothing
    } else {
        ssh-add $"~/.ssh/($key)" out+err> /dev/null | ignore
    }
}

def jjc [...args] {
    ^jj commit -m ...$args
}

def jjp [...args] {
    ^jj git push -b ...$args
}

if not (which fnm | is-empty) {
    ^fnm env --json | from json | load-env

    $env.PATH = $env.PATH | prepend ($env.FNM_MULTISHELL_PATH | path join (if $nu.os-info.name == 'windows' {''} else {'bin'}))
    $env.config.hooks.env_change.PWD = (
        $env.config.hooks.env_change.PWD? | append {
            condition: {|| ['.nvmrc' '.node-version', 'package.json'] | any {|el| $el | path exists}}
            code: {|| ^fnm use}
        }
    )
}
