# Orakl Network API

## Description

**Orakl Network API** 는 Orakl Network 배포를 위한 단일 정보 소스를 나타내는 추상화 계층입니다. 해당 코드는 [`api` directory](https://github.com/Bisonai/orakl/tree/master/api)&#x20; 에 위치해 있습니다.

**Orakl Network API** 는 모든 Orakl Network 서비스에서 접근 가능하며 [**Orakl Network CLI**](broken-reference)에서도 사용할 수 있어야 합니다. 이는 REST 웹 서버로 구현되어 다른 서비스로부터 요청을 받아들이며, Orakl Network의 상태는 PostgreSQL 데이터베이스에 저장됩니다. **Orakl Network API** 는 다른 마이크로 서비스보다 먼저 실행되고 구성되어야 합니다.

## Configuration

**Orakl Network API** 를 시작하기 전에 [몇 가지 환경 변수](https://github.com/Bisonai/orakl/blob/master/api/.env.example)를 지정해야 합니다. 환경 변수는 자동으로 `.env` 파일에서 로드됩니다.

- `DATABASE_URL`
- `APP_PORT`
- `ENCRYPT_PASSWORD`

`DATABASE_URL` 은 Orakl Network 상태를 저장할 데이터베이스에 대한 [연결 문자열](https://www.postgresql.org/docs/current/libpq-connect.html#LIBPQ-CONNSTRING) 을 나타냅니다.

> `DATABASE_URL` 의 형식은 `postgresql://[userspec@][hostspec][/dbname][?paramspec]` 입니다. 예를 들어, 다음과 같은 형식의 문자열이 될 수 있습니다: `postgresql://bisonai@localhost:5432/orakl?schema=public.`&#x20;

`APP_PORT`는 **Orakl Network API** 가 실행될 포트를 나타냅니다. 다른 서비스에서 **Orakl Network API** 에 연결할 때 이 포트가 필요합니다.

`ENCRYPT_PASSWORD` 는 Orakl Network API에 삽입된 개인 키의 암호화 및 복호화에 사용되는 암호화 키입니다.

## Launch

프로덕션의 소스 코드에서 **Orakl Network API** 를 시작하려면 먼저 서비스를 빌드한 다음 시작하실 수 있습니다.

```sh
yarn build
yarn start:prod
```

## Architecture

<figure><img src="../.gitbook/assets/orakl-network-api.png" alt=""><figcaption><p>Orakl Network API</p></figcaption></figure>
