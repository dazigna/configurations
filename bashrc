export CLICOLOR=1
export EDITOR=code
export BASH_SILENCE_DEPRECATION_WARNING=1

export PATH="/usr/local/opt/python/libexec/bin:$PATH"
eval "$(/opt/homebrew/bin/brew shellenv)"
 
# Get the current git branch
getGitPrompt() {
    local status="$(git status -s 2> /dev/null)"
    local branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    local prompt=""
 
    if [ -n "$branch" ]; then
        prompt=" ("
        prompt="$prompt$branch"
 
        if [ -n "$status" ]; then
            prompt="$prompt*"
        fi
 
        prompt="$prompt)"
    fi
 
    echo "${prompt}"
}
 
 
DIR_COLOR="\[\033[1;36m\]"    # cyan
GIT_COLOR="\[\033[1;37m\]"
PROMPT_COLOR="\[\033[1;35m\]"
CLEAR_COLOR="\[\033[0m\]"
DIRECTORY="\$PWD"
USER_COLOR="\[\033[0;32m\]"
PS1_PROMPT="\$"
 
PS1="
${USER_COLOR}${USER}\
${CLEAR_COLOR}[${DIR_COLOR}${DIRECTORY}${CLEAR_COLOR}]\
${GIT_COLOR}\$(getGitPrompt)\
${USER_COLOR}${PROMPT_DECOR} \
${PS1_PROMPT} ${CLEAR_COLOR}\
"

if [ -f ~/Sources/configurations/bash_aliases ]; then
    . ~/Sources/configurations/bash_aliases
fi


eval "$(direnv hook bash)"
export KITTY_CONFIG_DIRECTORY=~/Sources/configurations/kitty_configurations.conf
