#! /usr/bin/env nix-shell
#! nix-shell -i sh -p nodejs

npx -y --package="prettier" \
       --package="@prettier/plugin-ruby" \
       --package="prettier-plugin-erb" \
       -- prettier --parser erb -w $@
