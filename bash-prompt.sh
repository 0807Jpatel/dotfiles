#!/usr/bin/env bash

__powerline() {

    readonly GIT_BRANCH_SYMBOL='  '
    readonly GIT_BRANCH_CHANGED_SYMBOL=''
    readonly GIT_NEED_PUSH_SYMBOL='⇡'
    readonly GIT_NEED_PULL_SYMBOL='⇣'

    # Solarized colorscheme
    if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
        readonly FG_BASE03="\[$(tput setaf 234)\]"
        readonly FG_BASE02="\[$(tput setaf 235)\]"
        readonly FG_BASE01="\[$(tput setaf 240)\]"
        readonly FG_BASE00="\[$(tput setaf 241)\]"
        readonly FG_BASE0="\[$(tput setaf 244)\]"
        readonly FG_BASE1="\[$(tput setaf 245)\]"
        readonly FG_BASE2="\[$(tput setaf 254)\]"
        readonly FG_BASE3="\[$(tput setaf 230)\]"

        readonly FG_YELLOW="\[$(tput setaf 136)\]"
        readonly FG_ORANGE="\[$(tput setaf )\]"
        readonly FG_RED="\[$(tput setaf 160)\]"
        readonly FG_MAGENTA="\[$(tput setaf 125)\]"
        readonly FG_VIOLET="\[$(tput setaf 61)\]"
        readonly FG_BLUE="\[$(tput setaf 4)\]"
        readonly FG_CYAN="\[$(tput setaf 64)\]"
        readonly FG_GREEN="\[$(tput setaf 64)\]"

     else
        readonly FG_BASE03="\[$(tput setaf 8)\]"
        readonly FG_BASE02="\[$(tput setaf 0)\]"
        readonly FG_BASE01="\[$(tput setaf 10)\]"
        readonly FG_BASE00="\[$(tput setaf 11)\]"
        readonly FG_BASE0="\[$(tput setaf 12)\]"
        readonly FG_BASE1="\[$(tput setaf 14)\]"
        readonly FG_BASE2="\[$(tput setaf 7)\]"
        readonly FG_BASE3="\[$(tput setaf 15)\]"

        readonly FG_YELLOW="\[$(tput setaf 3)\]"
        readonly FG_ORANGE="\[$(tput setaf 9)\]"
        readonly FG_RED="\[$(tput setaf 1)\]"
        readonly FG_MAGENTA="\[$(tput setaf 5)\]"
        readonly FG_VIOLET="\[$(tput setaf 13)\]"
        readonly FG_BLUE="\[$(tput setaf 4)\]"
        readonly FG_CYAN="\[$(tput setaf 6)\]"
        readonly FG_GREEN="\[$(tput setaf 2)\]"

    fi

    readonly DIM="\[$(tput dim)\]"
    readonly REVERSE="\[$(tput rev)\]"
    readonly RESET="\[$(tput sgr0)\]"
    readonly BOLD="\[$(tput bold)\]"

    __git_info() { 
        [ -x "$(which git)" ] || return    # git not found

        local git_eng="env LANG=C git"   # force git output in English to make our work easier
        # get current branch name or short SHA1 hash for detached head
        local branch="$($git_eng symbolic-ref --short HEAD 2>/dev/null || $git_eng describe --tags --always 2>/dev/null)"
        [ -n "$branch" ] || return  # git branch not found

        local marks

        # branch is modified?
        [ -n "$($git_eng status --porcelain)" ] && marks+=" $GIT_BRANCH_CHANGED_SYMBOL"

        # how many commits local branch is ahead/behind of remote?
        local stat="$($git_eng status --porcelain --branch | grep '^##' | grep -o '\[.\+\]$')"
        local aheadN="$(echo $stat | grep -o 'ahead [[:digit:]]\+' | grep -o '[[:digit:]]\+')"
        local behindN="$(echo $stat | grep -o 'behind [[:digit:]]\+' | grep -o '[[:digit:]]\+')"
        [ -n "$aheadN" ] && marks+=" $GIT_NEED_PUSH_SYMBOL$aheadN"
        [ -n "$behindN" ] && marks+=" $GIT_NEED_PULL_SYMBOL$behindN"

        # print the git branch segment without a trailing newline
        printf "$GIT_BRANCH_SYMBOL$branch$marks"
    }

    ps1() {
        # Check the exit code of the previous command and display different
        # colors in the prompt accordingly. 

        if [ $? -eq 0 ]; then
            local BG_EXIT="$FG_GREEN "
        else
            local BG_EXIT="$FG_RED [$?]"
        fi

        PS1="$FG_CYAN\w$RESET"
        # Bash by default expands the content of PS1 unless promptvars is disabled.
        # We must use another layer of reference to prevent expanding any user
        # provided strings, which would cause security issues.
        # POC: https://github.com/njhartwell/pw3nage
        # Related fix in git-bash: https://github.com/git/git/blob/9d77b0405ce6b471cb5ce3a904368fc25e55643d/contrib/completion/git-prompt.sh#L324
        if shopt -q promptvars; then
            __powerline_git_info="$(__git_info)"
            PS1+="$FG_BLUE\${__powerline_git_info}$RESET"
        else
            # promptvars is disabled. Avoid creating unnecessary env var.
            PS1+="$FG_BLUE$FG_BASE3$(__git_info)$RESET"
        fi
        PS1+="$BG_EXIT$FG_BASE3 $RESET"
    }

    PROMPT_COMMAND=ps1
}

__powerline
unset __powerline
