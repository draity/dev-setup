# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH";

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
    shopt -s "$option" 2> /dev/null;
done;

# Add tab completion for many Bash commands
if which brew > /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
    source "$(brew --prefix)/share/bash-completion/bash_completion";
elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion;
fi;

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null && [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
    complete -o default -o nospace -F _git g;
fi;

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall;

#
# Use single ssh-agent launched by launchd
#
export SSH_ASKPASS=/usr/local/bin/ssh-ask-keychain
if test -f $HOME/.ssh-agent-pid && kill -0 `cat $HOME/.ssh-agent-pid` 2>/dev/null; then
  SSH_AUTH_SOCK=`cat $HOME/.ssh-auth-sock`
  SSH_AGENT_PID=`cat $HOME/.ssh-agent-pid`
  export SSH_AUTH_SOCK SSH_AGENT_PID
else

  # Discover the running ssh-agent started by launchd
  export SSH_AGENT_PID=$(pgrep -U $USER ssh-agent)
  if [ -n "$SSH_AGENT_PID" ]; then
    export SSH_AUTH_SOCK=$(lsof -U -a -p $SSH_AGENT_PID -F n | grep '^n/' | cut -c2-)
    echo "$SSH_AUTH_SOCK" >! ${HOME}/.ssh-auth-sock
    echo "$SSH_AGENT_PID" >! ${HOME}/.ssh-agent-pid
  else
    echo "No running ssh-agent found.  Check your launchd service."
  fi

  # Add all the local keys, getting the passphrase from keychain, helped by the $SSH_ASKPASS script.
  ssh-add < /dev/null
fi
