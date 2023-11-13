# Installation

## Running in Kubernetes

### Using Helm-Chart

Orakl Helm-Chart Repository [https://bisonai.github.io/orakl-helm-charts](https://bisonai.github.io/orakl-helm-charts)\
\
To install the chart with the release name <mark style="color:red;">my-release</mark>&#x20;

```shell
helm repo add orakl https://bisonai.github.io/orakl-helm-charts
```

#### Pre-requisition

To use Orakl, you need [<mark style="color:orange;">`Redis`</mark>](https://github.com/bitnami/charts/tree/main/bitnami/redis). If you have your `Redis` server, you can use it with settings later.&#x20;

example

```bash
helm repo add my-repo https://charts.bitnami.com/bitnami
helm install my-release my-repo/redis
```

#### 1) Deploying Orakl Storage

```bash
helm install orakl-storage orakl/orakl-storage
```

#### 2) Deploying orakl-cli

```bash
helm install \
 --set NODE_ENV=production \
 --set CHAIN=localhost \
 --set ORAKL_DIR=/app/db \
 --set LOG_LEVEL=debug \
 orakl-cli orakl/orakl-cli
```

After the successful deployment of `orakl-cli`, set up the configuration before installing VRF or Request-Response.

#### 3) Setting configuration
