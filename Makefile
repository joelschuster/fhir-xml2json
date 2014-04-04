.PHONY: all examples compare

all: examples

build/fhir-specs.zip:
	mkdir build && curl -L -o build/fhir-specs.zip 'http://www.hl7.org/documentcenter/public/standards/FHIR/fhir-spec.zip'

build/profiles-resources.xml: build/fhir-specs.zip
	(unzip -j -o build/fhir-specs.zip "*.xml" -d build || echo "OK"); \
	(unzip -j -o build/fhir-specs.zip "*example.json" -d build || echo "OK");

fhir-elements.xml: build/profiles-resources.xml
	saxonb-xslt -s:build/profiles-resources.xml -xsl:make-fhir-elements.xsl > fhir-elements.xml

examples: build/profiles-resources.xml fhir-elements.xml
	cd examples && make all

compare:
	for example in $(wildcard examples/*example.json); do \
	  fhirfile=build/`basename $$example`; \
		echo "Comparing $$example with $$fhirfile"; \
	  echo "--------------------------------------------------"; \
		cat $$fhirfile | python -mjson.tool > /tmp/fhir-variant.json; \
		diff -u /tmp/fhir-variant.json $$example; \
		echo "--------------------------------------------------"; \
	done;

clean:
	rm -rf fhir-elements.xml build/{*.xml,*.json} examples/*.json

