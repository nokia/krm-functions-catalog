# sleep

## Overview

<!--mdtogo:Short-->

Simulates a sleep delay based on the value provided in a ConfigMap field `duration`.

<!--mdtogo-->

This function introduces a deliberate delay in a kpt pipeline for debugging or simulation purposes.

It is helpful for use cases such as testing the timing and behavior of orchestrated pipelines where simulating latency is useful. For instance, it can help in evaluating the responsiveness and concurrency of pipeline steps.

<!--mdtogo:Long-->

## Usage

The `sleep` function is a utility that pauses execution for a user-defined number of seconds.

This can be used in both **imperative** (`kpt fn run`) and **declarative** (`functionConfig`) modes.

### FunctionConfig

The function expects a `ConfigMap` with a `data.duration` field to define how long to sleep.

- **duration**
    - *Type:* time.Time
    - *Example:* `"5s"`
    - *Optional:* Yes
    - *Default:* `"10s"`
    - *Description:* Number of seconds the function will pause execution.

Example FunctionConfig:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: sleep-config
data:
  duration: "5s"
```

<!--mdtogo-->

## Examples

<!--mdtogo:Examples-->

### Run imperatively

```sh
kpt fn run . --image gcr.io/kpt-fn/sleep --fn-config path/to/config.yaml
```

### Example Output

The function will log output like:

```
Sleeping for 5 seconds...
Sleep completed.
```

<!--mdtogo-->
