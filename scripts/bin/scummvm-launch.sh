#!/bin/sh

set -x

if [ -z "${XDG_CONFIG_HOME}" ]
then
  if [ -z "${HOME}" ]
  then XDG_CONFIG_HOME=$SNAP_USER_DATA/.config
  else XDG_CONFIG_HOME=${HOME}/.config
  fi
fi

# Hook up speech-dispatcher
mkdir -p $XDG_RUNTIME_DIR/speech-dispatcher
$SNAP/usr/bin/speech-dispatcher -d -C "$SNAP/etc/speech-dispatcher" -S "$XDG_RUNTIME_DIR/speech-dispatcher/speechd.sock" -m "$SNAP/usr/lib/speech-dispatcher-modules"

# We need to do this for the user that launches scummvm, so
# it can't be done on installation
while [ ! -f "${XDG_CONFIG_HOME}/scummvm/scummvm.ini" ]
do
  # Register the bundled games. We use a "while" loop as we can't easily
  # tell when scummvm is finished.
  mkdir -p ${XDG_CONFIG_HOME}
  $SNAP/bin/scummvm  -p /usr/share/scummvm/ --recursive --add
  sleep 1
done

exec $SNAP/bin/scummvm "$@"