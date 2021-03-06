#!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade --all

# Install GNU core utilities (those that come with OS X are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
sudo ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum

# Install some other useful utilities like `sponge`.
# brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed --with-default-names
# Install Bash 4.
brew install bash
brew tap homebrew/versions
brew install bash-completion2
# We installed the new shell, now we have to activate it
echo "Adding the newly installed shell to the list of allowed shells"
# Prompts for password
sudo bash -c 'echo /usr/local/bin/bash >> /etc/shells'
# Change to the new shell, prompts for password
chsh -s /usr/local/bin/bash

# Install `wget` with IRI support.
brew install wget --with-iri

# Install RingoJS and Narwhal.
# Note that the order in which these are installed is important;
# see http://git.io/brew-narwhal-ringo.
# brew install ringojs
# brew install narwhal

# Install Python
brew install python
brew install python3

# Install ruby-build and rbenv
brew install ruby-build
brew install rbenv
LINE='eval "$(rbenv init -)"'
grep -q "$LINE" ~/.extra || echo "$LINE" >> ~/.extra

# Install more recent versions of some OS X tools.
brew install vim --override-system-vi
brew install homebrew/dupes/grep
brew install homebrew/dupes/openssh
## Make ssh-agent useable with keychain
# NEED TO TURN OFF System Integrity Protection using Recovery (CMD+R at startup) and csrutil disable
# Autostart brew ssh-agent using launchd
sudo /usr/libexec/PlistBuddy /System/Library/LaunchAgents/org.openbsd.ssh-agent.plist<<EOF
Delete :ProgramArguments
Add :ProgramArguments array
Add :ProgramArguments: string /usr/local/bin/ssh-agent
Add :ProgramArguments: string -D
Add :ProgramArguments: string -t 1d
Save
Exit
EOF
launchctl unload /System/Library/LaunchAgents/org.openbsd.ssh-agent.plist
launchctl load -w /System/Library/LaunchAgents/org.openbsd.ssh-agent.plist
launchctl start org.openbsd.ssh-agent
# helper script to get passphrases via keychain
cat >/usr/local/bin/ssh-ask-keychain <<EOL
#!/bin/sh

security find-generic-password -l "SSH: /Users/david/.ssh/id_rsa" -gw
EOL
chmod u+x /usr/local/bin/ssh-ask-keychain

brew install homebrew/dupes/screen
brew install homebrew/php/php55 --with-gmp

# Install font tools.
# brew tap bramstein/webfonttools
# brew install sfnt2woff
# brew install sfnt2woff-zopfli
# brew install woff2

# Install some CTF tools; see https://github.com/ctfs/write-ups.
# brew install aircrack-ng
# brew install bfg
# brew install binutils
# brew install binwalk
# brew install cifer
# brew install dex2jar
# brew install dns2tcp
# brew install fcrackzip
# brew install foremost
# brew install hashpump
# brew install hydra
# brew install john
# brew install knock
# brew install netpbm
# brew install nmap
# brew install pngcheck
# brew install socat
# brew install sqlmap
# brew install tcpflow
# brew install tcpreplay
# brew install tcptrace
# brew install ucspi-tcp # `tcpserver` etc.
# brew install xpdf
# brew install xz

# Install other useful binaries.
brew install ack 			# faster, intuitive alternative to grep
# brew install dark-mode
brew install exiftool
brew install git
brew install git-lfs
brew install git-flow
brew install git-extras
brew install imagemagick --with-webp
brew install lua
# brew install lynx			# text based browser
brew install p7zip			# 7zip cli
brew install pigz			# parallel implementation of gzip
brew install pv				# Pipe Viewer is an Open Source tool to monitor the progress of data through a pipeline between any two processes, giving a progress bar, ETA, etc.
brew install rename			# rename utility
brew install rhino			# Rhino is an open-source implementation of JavaScript written entirely in Java. It is typically embedded into Java applications to provide scripting to end users. It is embedded in J2SE 6 as the default Java scripting engine.
# brew install speedtest_cli
brew install ssh-copy-id
brew install tree
brew install webkit2png
# brew install zopfli
brew install pkg-config libffi
brew install pandoc
brew install tmux
brew install entr			# Run arbitrary commands when files change
brew install android-platform-tools

# Lxml and Libxslt
brew install libxml2
brew install libxslt
brew link libxml2 --force
brew link libxslt --force

# Install Heroku
# brew install heroku-toolbelt
# heroku update

# Install Cask -> not needed anymore, included in home-brew
# brew install caskroom/cask/brew-cask

# Core casks
brew cask install --appdir="/Applications" alfred
brew cask install --appdir="/Applications" bettertouchtool
# brew cask install --appdir="~/Applications" iterm2
brew cask install --appdir="~/Applications" java
brew cask install --appdir="~/Applications" xquartz

# Development tool casks
# brew cask install --appdir="/Applications" sublime-text3
brew cask install --appdir="/Applications" atom
brew cask install --appdir="/Applications" virtualbox
brew cask install --appdir="/Applications" vagrant
# brew cask install --appdir="/Applications" heroku-toolbelt
# brew cask install --appdir="/Applications" macdown		# use atom markdown viewer instead

# Misc casks
brew cask install --appdir="/Applications" google-chrome
# brew cask install --appdir="/Applications" firefox
# brew cask install --appdir="/Applications" skype
# brew cask install --appdir="/Applications" slack
brew cask install --appdir="/Applications" dropbox
# brew cask install --appdir="/Applications" evernote
#brew cask install --appdir="/Applications" gimp
#brew cask install --appdir="/Applications" inkscape
brew cask install --appdir="/Applications" vlc
brew cask install --appdir="/Applications" spotify
brew cask install --appdir="/Applications" gitup
brew cask install --appdir="/Applications" flux
brew cask install --appdir="/Applications" macpass

#Remove comment to install LaTeX distribution MacTeX
brew cask install --appdir="/Applications" mactex

# Link cask apps to Alfred
# brew cask alfred link                                  # not working but also not needed?!

# Install Docker, which requires virtualbox
# brew install docker
# brew install boot2docker

# Install developer friendly quick look plugins; see https://github.com/sindresorhus/quick-look-plugins
brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzipql qlimagesize webpquicklook suspicious-package

# Remove outdated versions from the cellar.
brew cleanup
