package main

import (
	"fmt"
	"os"

	"github.com/kptdev/krm-functions-catalog/functions/go/test/sleep/processor"
	"sigs.k8s.io/kustomize/kyaml/fn/framework/command"
)

func main() {
	cmd := command.Build(&processor.SleepProcessor{}, command.StandaloneEnabled, false)
	cmd.Short = "Sleep function simulates a delay for testing purposes."
	cmd.Long = fmt.Sprintf(`The sleep function reads "duration" from FunctionConfig and delays execution.
The default duration is %s.
Useful for simulating latency in pipelines.`, processor.DefaultDuration)
	cmd.Example = `apiVersion: v1
kind: ConfigMap
metadata:
  name: sleep-config
data:
  duration: "5s"`

	if err := cmd.Execute(); err != nil {
		_, _ = fmt.Fprintf(os.Stderr, "ERROR: %s\n", err)
		os.Exit(1)
	}
}
