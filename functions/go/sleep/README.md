# sleep

## Overview

<!--mdtogo:Short-->

Simulates a sleep delay based on the provided `duration`.

<!--mdtogo-->

This function introduces a deliberate delay in a kpt pipeline for debugging or simulation purposes.

It is helpful for use cases such as testing the timing and behavior of orchestrated pipelines where simulating latency is useful.
For instance, it can help in evaluating the responsiveness and concurrency of pipeline steps.

<!--mdtogo:Long-->

## Usage

The `sleep` function is a utility that pauses execution for a user-defined amount of time.

This can be used in both **imperative** (`kpt fn eval`) and **declarative** (`functionConfig`) modes.

### FunctionConfig

The function expects a `ConfigMap` with a `data.duration` field to define how long to sleep.

- **duration**
  - *Type:* string (`time.Duration` format)
  - *Example:* `"5s"`
  - *Optional:* Yes
  - *Default:* `"10s"`
  - *Description:* Amount of time the function will pause execution.
- ~~**sleepSeconds**~~ (DEPRECATED)
  - *Type:* integer
  - *Example:* `5`
  - *Optional:* Yes
  - *Default:* `10`
  - *Description:* Number of seconds the function will pause execution.

<!--mdtogo-->

## Examples

<!--mdtogo:Examples-->

### Run imperatively

```sh
kpt fn eval --image ghcr.io/kptdev/krm-functions-catalog/sleep --fn-config path/to/config.yaml
```
or
```sh
kpt fn eval --image ghcr.io/kptdev/krm-functions-catalog/sleep -- duration=5s
```

### Example FunctionConfig

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: sleep-config
data:
  duration: "5s"
```

### Example Output

The function will log output like:

```
Sleeping for 5s...
Sleep completed.
```

<!--mdtogo-->
