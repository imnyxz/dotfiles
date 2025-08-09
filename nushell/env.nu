$env.PATH = ($env.PATH | append "/run/current-system/sw/bin" | append "/Users/offblck/.bun/bin" | append "/Users/offblck/.cargo/bin")

def jjc [...args] {
    ^jj commit -m ...$args
}

def jjp [...args] {
    ^jj git push -b ...$args
}
