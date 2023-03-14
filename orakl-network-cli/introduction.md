# Introduction

The **Orakl Network CLI** is a tool to configure and manage the **Orakl Network**.

* Chain
* Service
* Listener
* VRF
* Adapter
* Aggregator
* Orakl Network Fetcher

## Installation

We recommend to install the **Orakl Network CLI** globally using the command below.

```sh
npm install -g @bisonai/orakl-cli
```

After a successful installation, you can create an alias `orakl-cli` alias for the `@bisonai/orakl-cli` package. The alias can be defined in your shell configuration file (e.g. `.zshrc` or `.bashrc`). Setting up an alias is not mandatory, so feel free to use it directly with `npx @bisonai/orakl-cli` command.

```sh
echo "alias orakl-cli='npx @bisonai/orakl-cli'" >> ~/.zshrc
```

> Do not forget to restart your shell after the configuration file update!

After successful installation and a setup of `orakl-cli` alias, you can explore supported features using `--help` flag.

```sh
orakl-cli --help
```

The output of the command is shown below.

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
