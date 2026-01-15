package processor

import (
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"sigs.k8s.io/kustomize/kyaml/fn/framework"
	"sigs.k8s.io/kustomize/kyaml/yaml"
)

func TestSleepProcessor_DefaultSleep(t *testing.T) {
	p := &SleepProcessor{}
	rl := &framework.ResourceList{
		FunctionConfig: nil,
	}
	start := time.Now()
	err := p.Process(rl)
	require.NoError(t, err)
	duration := time.Since(start)
	assert.InDelta(t, DefaultDuration, duration, float64(1*time.Second))
}

func TestSleepProcessor_CustomSleep(t *testing.T) {
	node, err := yaml.Parse(`
apiVersion: v1
kind: ConfigMap
metadata:
  name: test-config
data:
  duration: "2s"
`)
	if err != nil {
		t.Fatalf("failed to parse yaml: %v", err)
	}

	p := &SleepProcessor{}
	rl := &framework.ResourceList{
		FunctionConfig: node,
	}
	start := time.Now()
	err = p.Process(rl)
	require.NoError(t, err)
	duration := time.Since(start)
	assert.InDelta(t, 2*time.Second, duration, float64(time.Second)/2)
}

func TestSleepProcessor_BackwardCompat(t *testing.T) {
	node, err := yaml.Parse(`
apiVersion: v1
kind: ConfigMap
metadata:
  name: test-config
data:
  sleepSeconds: "2"
`)
	if err != nil {
		t.Fatalf("failed to parse yaml: %v", err)
	}

	p := &SleepProcessor{}
	rl := &framework.ResourceList{
		FunctionConfig: node,
	}
	start := time.Now()
	err = p.Process(rl)
	require.NoError(t, err)
	duration := time.Since(start)
	assert.InDelta(t, 2*time.Second, duration, float64(time.Second)/2)
}
