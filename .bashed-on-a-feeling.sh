#!/bin/bash

#
#  ▓▓▓▓▓▓▓▓▓▓
# ░▓ author ▓ ikigai
# ░▓ code   ▓ https://github.com/yedhink/dotfiles_ikigai
# ░▓ 	    ▓
# ░▓▓▓▓▓▓▓▓▓▓
# ░░░░░░░░░░
#
# THIS IS A CUSTOM PROMPT THAT I MADE.
# TRIED TO MIMICK THE OH-MY-ZSH TERMINALPARTY THEME
# NOT FULLY FUNCTIONAL. BUT THE BARE NECESSECITIES ARE PRESENT
# I CALL THIS "bashed-on-a-feeling"
#gbranch          = "master"
#gbranch          = "$(tput bold)$(tput setaf 7)$gbranch"
#a_but_not_c      = `git diff --cached --name-only | wc -l`
#c_but_not_p      = `git diff --stat origin/master.. | wc -l`
#c_but_m_before_p = `git diff --name-status | wc -l`
#untracked        = `git ls-files --others --exclude-standard | wc -l`

read a_but_not_c c_but_not_p c_but_m_before_p untracked <<< $( echo | xargs -n 1 -P 8 ~/dotfiles_ikigai/scripts/blah/para.sh )

while read -ra Z; do
	if [[ "${Z[@]}" == \*\ * ]]; then
		gbranch="${Z[1]}"
		break
	fi
done <<< "$(/usr/bin/git branch 2> /dev/null)"
gbranch=`tput bold; tput setaf 7 ;echo "$gbranch"`


while read -r Z; do
	[[ "$Z" == commit* ]] && cno+=1
done <<< "$(/usr/bin/git log 2> /dev/null)"
commitstot=$cno
commiticon="\\uf737"
commiticon=`printf "%b\\n" "$commiticon"`

if [ $a_but_not_c -eq 0 ];then
	a_but_not_c=""
else
	a_but_not_c="$(tput bold)$(tput setaf 7)$a_but_not_c$(tput bold)$(tput setaf 2)"
fi

if [ $c_but_not_p -gt 0 ];then
	((c_but_not_p = c_but_not_p - 1 ))
fi

if [ $c_but_not_p == 0 ];then
	c_but_not_p="$(tput bold)$(tput setaf 2)"
else
	c_but_not_p="$(tput bold)$(tput setaf 7)$c_but_not_p$(tput bold)$(tput setaf 2)"
fi

if [ $c_but_m_before_p -eq 0 ];then
	c_but_m_before_p=""
else
	c_but_m_before_p="$(tput bold)$(tput setaf 7)$c_but_m_before_p$(tput bold)$(tput setaf 2)"
fi

if [ $untracked -eq 0 ];then
	untracked=""
else
	untracked="$(tput bold)$(tput setaf 7)$untracked$(tput bold)$(tput setaf 2)"
fi
# Create a string
printf -v PS1RHS "\e[0m \e[0;1;31m%s %s %s %s %s\e[0m" "$gbranch" "$a_but_not_c" "$c_but_not_p" "$c_but_m_before_p" "$untracked"

# Strip ANSI commands before counting length
PS1RHS_stripped=$(sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" <<<"$PS1RHS")


local Save='\e[s' # Save cursor position
local Rest='\e[u' # Restore cursor to save point

#while read -r Z; do
#	[[ "$Z" == commit* ]] && cno+=1
#done <<< "$(/usr/bin/git log 2> /dev/null)"
#commitstot=$cno
#commiticon="\\uf737"
#commiticon=`printf "%b\\n" "$commiticon"`

# Save cursor position, jump to right hand edge, then go left N columns where
# N is the length of the printable RHS string. Print the RHS string, then
# return to the saved position and print the LHS prompt.

# Note: "\[" and "\]" are used so that bash can calculate the number of
# printed characters so that the prompt doesn't do strange things when
# editing the entered text.

# ensure that this PS1 and corresponding ANSI Seq's are closed properly
#PS1='\[\e[0;31m\]♥ \e[0;31m\]\W \[\e[1;33m\]\$\[\e[0m\] '
PS1='\[\e[1;33;3m\]\w \[\e[0m\]$(tput setaf 2)$(tput bold)$commitstot $commiticon\n $(tput setaf 7)$(tput bold)$(tput setab 4) \[\e[0m\] '
export PS1="\[${Save}\e[${COLUMNS}C\e[${#PS1RHS_stripped}D${PS1RHS}${Rest}\]${PS1}"