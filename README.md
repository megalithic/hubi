# Hubi

A CLI tool to interface with your local [Hubitat](https://hubitat.com/) home
automation hub.

> Inspiration: https://github.com/megalithic/dotfiles/blob/master/bin/hubitat

This Elixir project, and the shell script above, came about because I wanted to
automate some things with my Hubitat hub, via
[Hammerspoon](https://www.hammerspoon.org/), and also because I work primarily
on the command line.

See the [Hubitat Maker App Docs](https://docs.hubitat.com/index.php?title=Hubitat%E2%84%A2_Maker_API)
for more info on what can be done via HTTP.

### Setup

You must have the following system environment variables defined:

```sh
HUBITAT_TOKEN
HUBITAT_APP_ID_MAKER
HUBITAT_LAN
```

_Note:_ setup and configuration will most certainly change and be **better**.

### Usage

[Download the `hubi` binary](https://github.com/megalithic/hubi/raw/master/hubi)
and place it in your system's `$PATH`.

```sh
usage: hubi [--verbose] <command> [<args>]

Commands
  device    Device Status/Info (requires a device_id)
  devices   Device listing
```

### Development

To setup the repo:

```sh
bin/setup
```

To build/compile for release:

```sh
bin/build
```

#### TODO

- [ ] Finish formatting of device status/info
- [ ] Implement ability to do simple on/off operations to switches/et al
- [ ] Implement interactive operations on the returned list of devices

#### Attribution

Huge props to [@alnguyen](https://github.com/alnguyen) for the project name and the encouragement to build this.
