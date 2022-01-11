alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ls='ls -a'
alias ..='cd ..'

alias sudo='sudo '
alias bc='bc -l'
alias mkdir='mkdir -pv'
alias mv='mv -iv'
alias cp='cp -iv'
cd() { builtin cd "$@" && ls; }

extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}


if [ -f ~/Sources/configurations/git_aliases ]; then
    . ~/Sources/configurations/git_aliases
fi
