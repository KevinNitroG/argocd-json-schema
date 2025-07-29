SCHEMA_DIR=./schemas

.PHONY: gen-schemas

gen-schemas:
	./scripts/generate-schemas.sh ${SCHEMA_DIR}
