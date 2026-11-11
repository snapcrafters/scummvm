#!/bin/sh

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-${HOME:-$SNAP_USER_DATA}/.config}"
config_dir="$XDG_CONFIG_HOME/scummvm"

if snapctl is-connected audio-playback; then
  # Keep the private speech service used by ScummVM's Linux TTS backend.
  mkdir -p "$XDG_RUNTIME_DIR/speech-dispatcher"
  "$SNAP/usr/bin/speech-dispatcher" -d -C "$SNAP/etc/speech-dispatcher" \
    -S "$XDG_RUNTIME_DIR/speech-dispatcher/speechd.sock" \
    -m "$SNAP/usr/lib/speech-dispatcher-modules" -t 30
else
  echo "WARNING: audio-playback interface not connected, speech and audio will not work." >&2
fi

if [ ! -f "$config_dir/scummvm.ini" ]; then
  mkdir -p "$config_dir"
  printf '[scummvm]\naspect_ratio=true\ngfx_mode=opengl\n\n[cloud]\nrootpath=%s/current/.local/share/scummvm\n' \
    "${SNAP_USER_DATA%/*}" > "$config_dir/scummvm.ini"
fi

# Register games per user, not in an installation hook. Retry a failed import.
if [ ! -f "$config_dir/.added-games-bundle" ]; then
  if grep -Eq "comi|drascula|dreamweb|lure|myst|queen|sky|sword" "$config_dir/scummvm.ini" ||
    "$SNAP/usr/local/bin/scummvm" -p /usr/share/scummvm/ --recursive --add; then
    touch "$config_dir/.added-games-bundle"
  fi
fi

exec "$SNAP/usr/local/bin/scummvm" "$@"
