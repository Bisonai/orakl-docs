---
description: Take Control Of The Orakl Network With CLI
---

# Introduction

The **Orakl Network CLI** is a tool to configure and manage the **Orakl Network**. The configurable parts of the Orakl Network are listed below:

* [Chain](chain.md)
* [Service](service.md)
* [Listener](listener.md)
* [VRF Keys](vrf-keys.md)
* [Adapter](adapter.md)
* [Aggregator](aggregator.md)
* [Orakl Network Data Feed](fetcher.md)

### Installation

We recommend to install the **Orakl Network CLI** globally using the command below.

```sh
npm install -g @bisonai/orakl-cli
```

After a successful installation, you can start using it with `npx @bisonai/orakl-cli` command. To list all of supported features, you can use the `--help` flag.

```sh
npx @bisonai/orakl-cli --help
```

The output of the `--help` command is displayed below.

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

### Setup Alias

The Orakl Network CLI is a tool that node operators will use quite frequently. It might feel clumsy to keep rewriting the  `@bisonai/` prefix at every command. To combat that we recommend to create an `orakl-cli` alias for the `@bisonai/orakl-cli` package. The alias can be defined in your shell configuration file (e.g. `.zshrc` or `.bashrc`).&#x20;

```sh
echo "alias orakl-cli='npx @bisonai/orakl-cli'" >> ~/.zshrc
```

> Do not forget to restart your shell after the configuration file update!

### Configuration

The **Orakl Network CLI** needs to communicate with several services of the Orakl Network in order to perform correctly. The state of the Orakl Network is controlled through the **Orakl Network API**, and data collection for the **Orakl Network Aggregator** is controlled by the **Orakl Network Fetcher**.

To fully configure the **Orakl Network CLI**, setup the following environment variables.

* `ORAKL_NETWORK_API_URL`
* `ORAKL_NETWORK_FETCHER_URL`

`ORAKL_NETWORK_API_URL` and `ORAKL_NETWORK_FETCHER_URL` environment variables represent URLs for communication with the **Orakl Network API** and the **Orakl Network Fetcher**, respectively.
