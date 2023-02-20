# Camwall

.. is a _free, self-hosted_ alternative to shodan images, with an additional camera validation step.

Images is one of the premium features of Shodan, you need a paid account to use it. This is a self-hosted alternative to it, that works with _only_ a (paid) API key. 

I will keep the acquiring of such API keys for free as an exercise to the reader :)

Most of the cams you'd find on Shodan Images don't work btw — they either time out or the channel can't be found. To make sure all cameras collected work, camwall has an additional probing step (hence the `ffmpeg` dependency for `ffprobe`) that validates each camera.

## Dependencies

You must have ruby 3.0.* with bundler. 

The only extra dependency that won't be installed by bundler is `ffmpeg`. Install that using your package manager.

## Nix shortcut

If you use nix (the package manager), there is a `devenv.sh` file that sets up everything.
