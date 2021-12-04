check: description-lint code-lint schema-validate test

description-lint:
	yamllint modules

test:
	@(for i in $$(find modules/** -type f -name Makefile); do make test -C $$(dirname $$i) || exit 1; done)


SUBDIRS := $(wildcard modules/**/*/.)

schema-validate: $(SUBDIRS)
$(SUBDIRS):
	yq . $@/description.ru.yml > /tmp/current-description.json && ajv -s /opt/basics/common/schema.json -d /tmp/current-description.json
	yq . $@/description.en.yml > /tmp/current-description.json && ajv -s /opt/basics/common/schema.json -d /tmp/current-description.json || true

.PHONY: all test $(SUBDIRS)
