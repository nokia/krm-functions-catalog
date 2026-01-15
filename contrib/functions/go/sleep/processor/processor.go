package processor

import (
	"fmt"
	"os"
	"strconv"
	"strings"
	"time"

	"sigs.k8s.io/kustomize/kyaml/fn/framework"
)

const DefaultDuration = 10 * time.Second

type SleepProcessor struct{}

func (p *SleepProcessor) Process(rl *framework.ResourceList) error {
	duration := DefaultDuration
	fnConfig := rl.FunctionConfig
	if fnConfig != nil && fnConfig.GetKind() == "ConfigMap" {
		data := fnConfig.GetDataMap()
		if data == nil {
			err := fmt.Errorf("couldn't parse FunctionConfig's data field")
			return err
		}

		if raw, ok := data["duration"]; ok {
			raw = strings.TrimSpace(raw)
			if parsed, err := time.ParseDuration(raw); err == nil {
				duration = parsed
			} else {
				return fmt.Errorf("couldn't parse `duration` field of functionConfig: %w", err)
			}
		} else /* for BC */ if raw, ok = data["sleepSeconds"]; ok {
			raw = strings.TrimSpace(raw)
			if parsed, err := strconv.Atoi(raw); err == nil {
				duration = time.Duration(parsed) * time.Second
			} else {
				return fmt.Errorf("couldn't parse `sleepSeconds` field of functionConfig: %w", err)
			}
		}
	}
	fmt.Fprintf(os.Stderr, "Sleeping for %s...\n", duration)
	time.Sleep(duration)
	fmt.Fprintln(os.Stderr, "Sleep completed.")
	return nil
}
