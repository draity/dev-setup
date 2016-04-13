#!/usr/bin/env bash

# Install ruby gems.

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

if hash gem 2>/dev/null; then
    gem install maid
else
    echo -e "\e[31mFailed to install ruby gems because command \e[33mgem\e[31m does not exist\e[0m"
fi
