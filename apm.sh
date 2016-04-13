#!/usr/bin/env bash

# Install atom packages using apm.

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

if hash apm 2>/dev/null; then
    apm install highlight-selected
    apm install minimap
    apm install markdown-preview-plus
    apm install markdown-preview-plus-opener
    apm install markdown-mindmap
    apm install todo-show
    apm install atom-ternjs
    apm install sublime-style-column-selection
    apm install auto-detect-indentation
    apm isntall editorconfig
    apm install linter
    apm install linter-jshint
    apm install open-recent
    apm install pigments
fi
