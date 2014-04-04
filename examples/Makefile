all: observation1.json patient1.json observation2.json patient2.json questionnaire1.json questionnaire2.json questionnaire3.json

observation1.json:
	cd .. && saxonb-xslt -s:build/observation-example-f001-glucose.xml -xsl:fhir-xml2json.xsl | python -mjson.tool > examples/observation1.json

observation2.json:
	cd .. && saxonb-xslt -s:build/observation-example-f002-excess.xml -xsl:fhir-xml2json.xsl | python -mjson.tool > examples/observation2.json

patient1.json:
	cd .. && saxonb-xslt -s:build/patient-example-a.xml -xsl:fhir-xml2json.xsl | python -mjson.tool > examples/patient1.json

patient2.json:
	cd .. && saxonb-xslt -s:build/patient-example-b.xml -xsl:fhir-xml2json.xsl | python -mjson.tool > examples/patient2.json

questionnaire1.json:
	cd .. && saxonb-xslt -s:build/questionnaire-example-bluebook.xml -xsl:fhir-xml2json.xsl | python -mjson.tool > examples/questionnaire1.json

questionnaire2.json:
	cd .. && saxonb-xslt -s:build/questionnaire-example.xml -xsl:fhir-xml2json.xsl | python -mjson.tool > examples/questionnaire2.json

questionnaire3.json:
	cd .. && saxonb-xslt -s:build/questionnaire-example-f201-lifelines.xml -xsl:fhir-xml2json.xsl | python -mjson.tool > examples/questionnaire3.json
