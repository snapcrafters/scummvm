#!/bin/sh

real_xdg_runtime_dir=$(dirname "${XDG_RUNTIME_DIR}")
case "${WAYLAND_DISPLAY:-wayland-0}" in
  /*) real_wayland=$WAYLAND_DISPLAY ;;
  *) real_wayland=${real_xdg_runtime_dir}/${WAYLAND_DISPLAY:-wayland-0} ;;
esac

if [ ! -O "${real_wayland}" ]; then
  # On core systems mir-kiosk may also need to create the host XDG_RUNTIME_DIR
  if [ ! -O "${real_xdg_runtime_dir}" ]; then
    echo waiting for host XDG_RUNTIME_DIR...
    until [ -O "${real_xdg_runtime_dir}" ]
    do
      inotifywait --event create "$(dirname "${real_xdg_runtime_dir}")" || sleep 4
    done
  fi

  echo waiting for Wayland socket...
  until [ -O "${real_wayland}" ]
  do
    inotifywait --event create "$(dirname "${real_wayland}")" || sleep 4
  done

  echo ...waiting done
fi

# Desktop setup may precede the compositor at boot. Use the host socket
# directly rather than relying on a snap-local link created before the wait.
export WAYLAND_DISPLAY="$real_wayland"
exec "$@"
