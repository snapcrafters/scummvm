#!/bin/sh

case "${WAYLAND_DISPLAY:-wayland-0}" in
  /*) ;;
  *) WAYLAND_DISPLAY="$(dirname "$XDG_RUNTIME_DIR")/${WAYLAND_DISPLAY:-wayland-0}" ;;
esac
export WAYLAND_DISPLAY

until [ -S "$WAYLAND_DISPLAY" ] && [ -O "$WAYLAND_DISPLAY" ]; do
  sleep 1
done
exec "$@"
