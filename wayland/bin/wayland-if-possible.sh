#!/bin/sh

if [ -O "${XDG_RUNTIME_DIR}/wayland-0" ]; then export SDL_VIDEODRIVER=wayland; fi

exec "$@"