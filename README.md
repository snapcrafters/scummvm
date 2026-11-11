<h1 align="center">
  <img src="snap/gui/scummvm.png" alt="ScummVM">
</h1>

<p align="center"><b>This is the snap for ScummVM</b>. It is a community-maintained package to easily install ScummVM on Ubuntu, Fedora, Debian and other major Linux distributions. It is available in the Snap Store, Ubuntu Software, and a number of other applications.</p>

<p align="center"><i>"Play classic graphical adventure games on modern systems."</i></p>

<p align="center">
<a href="https://snapcraft.io/scummvm"><img src="https://snapcraft.io/scummvm/badge.svg" alt="Snap Status"></a>
<a href="https://github.com/snapcrafters/scummvm/actions/workflows/sync-version-with-upstream.yml"><img src="https://github.com/snapcrafters/scummvm/actions/workflows/sync-version-with-upstream.yml/badge.svg?branch=candidate" alt="Sync version with upstream"></a>
<a href="https://github.com/snapcrafters/scummvm/actions/workflows/release-to-candidate.yml"><img src="https://github.com/snapcrafters/scummvm/actions/workflows/release-to-candidate.yml/badge.svg?branch=candidate" alt="Release to candidate"></a>
<a href="https://github.com/snapcrafters/scummvm/actions/workflows/promote-to-stable.yml"><img src="https://github.com/snapcrafters/scummvm/actions/workflows/promote-to-stable.yml/badge.svg?branch=candidate" alt="Promote to stable"></a>
</p>

## Install

    sudo snap install scummvm

([Don't have snapd installed?](https://snapcraft.io/docs/core/install))

<p align="center">Published for Linux by Snapcrafters</p>

Launch ScummVM from your desktop's application menu or run `scummvm`.

## Snap configuration

### Games and device access

The snap includes a games bundle, which the launcher registers on first use unless it detects an existing selection of games. To play other supported games, you must supply their original data files and add them through ScummVM's game launcher.

For games stored on removable drives, or to use a joystick, connect the relevant interfaces:

    sudo snap connect scummvm:removable-media
    sudo snap connect scummvm:joystick

### Text-to-speech

The snap is built with text-to-speech support and bundles Speech Dispatcher and eSpeak NG. The launcher starts Speech Dispatcher when `audio-playback` is connected. Speech and audio require that interface; if it has been disconnected, reconnect it with:

    sudo snap connect scummvm:audio-playback

Enable the relevant speech options in ScummVM where supported by the game or interface.

### Kiosk daemon

The snap also provides a full-screen Wayland service, `scummvm.daemon`. Its `daemon` configuration option defaults to `true` when the configure hook detects an Ubuntu Core boot (`snap_core=` or `snapd_recovery_mode=` in the kernel command line), and to `false` otherwise. The configured value is preserved on subsequent hook runs.

    sudo snap set scummvm daemon=true
    sudo snap set scummvm daemon=false

These commands enable/start or disable/stop the service respectively. Kiosk use requires a running Wayland compositor, such as a compatible Mir kiosk, and the appropriate `scummvm:wayland` connection. The daemon waits for the Wayland socket before starting ScummVM; enabling it alone does not provide a compositor. Inspect it with `snap services scummvm` and `sudo snap logs scummvm.daemon`.

## How to contribute to this snap

### Reporting issues

Please [open an issue](https://github.com/snapcrafters/scummvm/issues) if you find a packaging bug, have a feature request, or if the snap is out of date. Report application issues to the [ScummVM project](https://www.scummvm.org/).

### Initial setup

Fork this repository and clone your fork, then add the upstream remote:

    git remote rename origin myfork
    git remote add snapcrafters https://github.com/snapcrafters/scummvm.git
    git fetch --all

### Submitting changes in a pull request

Create a branch from `candidate`, the packaging release branch:

    git fetch --all -p
    git checkout -b my-bugfix-branch snapcrafters/candidate

Make your changes and build locally with `snapcraft`. Commit and push the branch to your fork, then open a pull request against `candidate`. The PR workflow builds and reviews the amd64 snap; artifacts are available from the Actions run. A maintainer reviews the change before merging.

Snap versions are [automatically kept in sync](https://github.com/snapcrafters/scummvm/actions/workflows/sync-version-with-upstream.yml) daily with the latest published non-prerelease GitHub release from `scummvm/scummvm`. The updater accepts a numeric three-component version, optionally prefixed with `v`, and updates the single top-level recipe version. An unchanged version produces no commit; an invalid release response fails without editing the recipe.

Merging into `candidate` builds the recipe's architecture matrix on Launchpad, publishes to `latest/candidate`, and creates a testing issue with GUI screenshots. After testing, an authorized maintainer can promote the eligible revisions to `latest/stable` using the command in that issue.

### Testing

Subscribe to the [candidate channel](https://snapcraft.io/scummvm) and [leave a comment](https://github.com/snapcrafters/scummvm/issues) on the relevant testing issue with your results.

    sudo snap install scummvm --channel=candidate

For an existing installation use `sudo snap refresh scummvm --channel=candidate`. Include the installed revision and architecture with test results. Check launching the GUI, bundled and user-provided games, audio and text-to-speech, removable-media access, and joystick input where available. If you use kiosk mode, test the daemon with your Wayland compositor too.

## Maintainers

This packaging is maintained by the [Snapcrafters community](https://github.com/snapcrafters). Contributions and testing reports are welcome through this repository's issues and pull requests.

## License

The packaging scripts and documentation in this repository are released under the [MIT License](LICENSE). ScummVM itself is licensed under the [GNU General Public License](https://github.com/scummvm/scummvm/blob/master/COPYING); bundled games and third-party components retain their respective licenses.
