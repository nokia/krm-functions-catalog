package main

import (
	"fmt"
	"os"

	"github.com/kptdev/krm-functions-catalog/functions/go/sleep/generated"
	"github.com/kptdev/krm-functions-catalog/functions/go/sleep/processor"
	"sigs.k8s.io/kustomize/kyaml/fn/framework/command"
)

func main() {
	cmd := command.Build(&processor.SleepProcessor{}, command.StandaloneEnabled, false)
	cmd.Short = generated.SleepShort
	cmd.Long = generated.SleepLong
	cmd.Example = generated.SleepExamples

	if err := cmd.Execute(); err != nil {
		_, _ = fmt.Fprintf(os.Stderr, "ERROR: %s\n", err)
		os.Exit(1)
	}
}
