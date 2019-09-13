# Hubi

A CLI tool to interface with your local Hubitat home automation hub.

| Inspiration: https://github.com/megalithic/dotfiles/blob/master/bin/hubitat

### Setup

You must have the following system environment variables defined:

```sh
HUBITAT_TOKEN
HUBITAT_MAKER_APP_ID
HUBITAT_LAN
```

_Note:_ setup and configuration will most certainly change and be **better**.

### Usage

```sh
usage: hubi [--verbose] <command> [<args>]

Commands
  status    Device Status/Info
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
