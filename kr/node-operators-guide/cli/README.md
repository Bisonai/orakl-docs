---
description: Take Control Of The Orakl Network With CLI
---

# Orakl Network CLI

**Orakl Network CLI** 는 **Orakl Network** 를 구성하고 관리하기 위한 도구입니다. **Orakl Network CLI** 를 사용하면 Orakl Network의 상태에 대한 액세스와 수정이 가능하므로, 노드 운영자에게 매우 중요한 도구입니다. 해당 코드는 [`cli` 디렉토리](../../developers-guide/data-feed.md)에 위치해 있습니다. Orakl Network의 구성 가능한 부분은 다음과 같습니다:

- [Chain](chain.md)
- [Service](service.md)
- [Listener](listener.md)
- [VRF Keys](vrf-keys.md)
- [Adapter](adapter.md)
- [Aggregator](aggregator.md)
- [Reporter](reporter.md)
- [Fetcher](fetcher.md)
- [Delegator](delegator.md)

### Installation

아래의 command를 사용하여 **Orakl Network CLI** 를 전역적으로 설치하는 것을 권장합니다.

```sh
npx @bisonai/orakl-cli
```

설치가 완료된 후에는 동일한 command인 `npx @bisonai/orakl-cli` 사용하여 Orakl Network CLI를 사용하실 수 있습니다. 모든 지원 기능을 나열하려면 `--help` 플래그를 사용하실 수 있습니다.

```sh
npx @bisonai/orakl-cli --help
```

아래는 --help command의 출력 예시입니다:

```
operator <subcommand>

where <subcommand> can be one of:

- chain
- service
- listener
- vrf
- adapter
- aggregator
- fetcher
- reporter
- version

For more help, try running `operator <subcommand> --help`
```

### Setup Alias

Orakl Network CLI는 노드 운영자들이 자주 사용하게 될 도구입니다. 매번 command를 입력할 때마다 `@bisonai/` 접두사를 반복하는 것은 번거로울 수 있습니다. 이를 해결하기 위해 `@bisonai/orakl-cli` 패키지에 대한 `orakl-cli` 별칭을 만드는 것을 권장합니다. 이 별칭은 쉘 구성 파일 (예: `.zshrc` 또는 `.bashrc`)에 정의할 수 있습니다.&#x20;

```sh
echo "alias orakl-cli='npx @bisonai/orakl-cli'" >> ~/.zshrc
```

> 설정 파일을 업데이트한 후에는 쉘을 재시작하는 것을 잊지 마세요!

### Configuration

**Orakl Network CLI** 는 올바르게 작동하기 위해 Orakl Network의 여러 서비스와 통신해야 합니다. Orakl Network의 상태는 **Orakl Network API** 통해 제어되며, **Orakl Network Aggregator** 의 데이터 수집은 **Orakl Network Fetcher** 에 의해 제어됩니다.

**Orakl Network CLI** 를 완전하게 구성하시려면 다음과 같은 환경 변수를 설정하세요.

- `ORAKL_NETWORK_API_URL`
- `ORAKL_NETWORK_FETCHER_URL`
- `ORAKL_NETWORK_DELEGATOR_URL`
- `LISTENER_SERVICE_HOST`
- `LISTENER_SERVICE_PORT`
- `WORKER_SERVICE_HOST`
- `WORKER_SERVICE_PORT`
- `REPORTER_SERVICE_HOST`
- `REPORTER_SERVICE_PORT`

`ORAKL_NETWORK_API_URL` , `ORAKL_NETWORK_FETCHER_URL` 및 `ORAKL_NETWORK_DELEGATOR_URL` 환경 변수는 각각 **Orakl Network API**, **Orakl Network Fetcher** 및 **Orakl Network Delegator** 와의 통신을 위한 URL을 나타냅니다.

**Orakl Network CLI** 는 **Orakl Network Watchman** 을 통해 특정 리스너, 워커 및 리포터와 통신할 수 있습니다. 이 기능을 활성화하기 위해서는 **Orakl Network CLI** 가 아래에 나와 있는 각 서비스를 위한 환경 변수를 설정해야 합니다.

- Listener (`LISTENER_SERVICE_HOST`, `LISTENER_SERVICE_PORT)`
- Worker (`WORKER_SERVICE_HOST`, `WORKER_SERVICE_PORT`)
- Reporter (`REPORTER_SERVICE_HOST`, `REPORTER_SERVICE_PORT)`
