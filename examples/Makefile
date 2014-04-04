EXAMPLES = build/adversereaction-example.xml \
					 build/alert-example.xml \
					 build/allergyintolerance-example.xml \
					 build/careplan-example.xml \
					 build/composition-example.xml \
					 build/conceptmap-example.xml \
					 build/condition-example.xml \
					 build/conformance-example.xml \
					 build/conformance-phr-example.xml \
					 build/device-example.xml \
					 build/deviceobservationreport-example.xml \
					 build/diagnosticorder-example.xml \
					 build/diagnosticreport-example.xml \
					 build/documentmanifest-example.xml \
					 build/documentreference-example.xml \
					 build/encounter-example.xml \
					 build/familyhistory-genetics-profile-example.xml \
					 build/group-example.xml \
					 build/imagingstudy-example.xml \
					 build/immunization-example.xml \
					 build/list-example.xml \
					 build/location-example.xml \
					 build/media-example.xml \
					 build/medicationadministration-example.xml \
					 build/medicationdispense-example.xml \
					 build/medication-example.xml \
					 build/medicationprescription-example.xml \
					 build/medicationstatement-example.xml \
					 build/messageheader-example.xml \
					 build/observation-example.xml \
					 build/operationoutcome-example.xml \
					 build/order-example.xml \
					 build/orderresponse-example.xml \
					 build/organization-example.xml \
					 build/patient-example.xml \
					 build/patient-glossy-example.xml \
					 build/practitioner-example.xml \
					 build/procedure-example.xml \
					 build/provenance-example.xml \
					 build/questionnaire-example.xml \
					 build/questionnaire-extensions-example.xml \
					 build/relatedperson-example.xml \
					 build/securityevent-example.xml \
					 build/specimen-example.xml \
					 build/substance-example.xml \
					 build/supply-example.xml \
					 build/valueset-example.xml \
					 # build/xds-example.xml
					 # build/other-example.xml
					 # build/query-example.xml
					 # build/immunizationrecommendation-example.xml
					 # build/familyhistory-example.xml

all:
	cd ..; \
	for example in $(EXAMPLES); do \
		echo "Converting $$example"; \
	  rawfile=`basename $${example%.*}.raw.json`; \
	  saxonb-xslt -s:$$example -xsl:fhir-xml2json.xsl > examples/$$rawfile; \
	  cat examples/$$rawfile | python -mjson.tool > examples/$${rawfile%%.*}.json; \
	done;
