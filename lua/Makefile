TEST_FILES := $(sort $(wildcard test_*.lua))

.PHONY: tests

tests:
	@for t in $(TEST_FILES); do texlua ./$$t || exit 1; done

