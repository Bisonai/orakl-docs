# Introduction

The Orakl Network CLI is a tool to configure and manage Orakl Network.

* Adapter
* Aggregator
* Listener
* VRF
* Fetcher

## Installation

We recommend to install the Orakl Network CLI globally using the command below

```sh
npm install -g @bisonai/orakl-cli
```

and create an alias from `@bisonai/orakl-cli` to `orakl-cli`. The alias can be defined in your shell configuration file (e.g. `.zshrc` or `.bashrc`). Setting up an alias is not mandatory, so feel free to use it directly with `npx @bisonai/orakl-cli` command.

```sh
echo "alias orakl-cli='npx @bisonai/orakl-cli'" >> ~/.zshrc
```

> Do not forget to restart your shell after the configuration file update!

After successful installation and setup of `orakl-cli` alias, you can explore supported features using `--help` flag

```sh
orakl-cli --help
```

which produces the output below

```
operator <subcommand>

where <subcommand> can be one of:

- migrate
- chain
- service
- listener
- vrf
- adapter
- aggregator
- fetcher

For more help, try running `operator <subcommand> --help`
```

### Setup alias
