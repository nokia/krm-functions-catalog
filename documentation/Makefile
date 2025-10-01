serve: copy-examples
	hugo server \
		--disableFastRender \
		--buildDrafts \
		--buildFuture \
		--ignoreCache
		--printI18nWarnings \
		--printMemoryUsage \
		--printPathWarnings \
		--printUnusedTemplates \
		--templateMetrics \
		--templateMetricsHints \
		--gc

production-build: copy-examples
	git submodule update --init --recursive
	hugo version
	hugo \
		--minify
	npx -y pagefind --site public

preview-build: copy-examples
	git submodule update --init --recursive
	hugo \
		--baseURL $(DEPLOY_PRIME_URL) \
		--buildDrafts \
		--buildFuture \
		--minify
	npx -y pagefind --site public

copy-examples:
#	mkdir -p public/examples
#	cp -R ../examples public/examples

	mkdir -p content/en/
	cp -R ../examples content/en/examples