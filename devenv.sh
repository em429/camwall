#!/usr/bin/env bash

nix-shell --command zsh \
          -p ruby_3_0 \
          mailcatcher nodejs chromedriver ffmpeg;

gem install solargraph;
gem install foreman;
