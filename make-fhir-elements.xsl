<?xml version="1.0"?>

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fh="http://hl7.org/fhir"
                xpath-default-namespace="http://hl7.org/fhir"
                exclude-result-prefixes="fh">

  <xsl:output method="xml" version="1.0"
              encoding="UTF-8" indent="yes"/>

  <!-- capitalizes first letter -->
  <xsl:function name="fh:capitalize-first">
    <xsl:param name="str" />
    <xsl:value-of select="concat(upper-case(substring($str,1,1)),
                          substring($str, 2))" />
  </xsl:function>

  <!-- expands path with [x] to many paths, each with concrete type
       -->
  <xsl:template name="expandPolymorphic">
    <xsl:param name="path" />
    <xsl:param name="min" />
    <xsl:param name="max" />
    <xsl:param name="weight" />
    <xsl:param name="type" select="('integer', 'decimal', 'dateTime',
                                              'date', 'instant', 'string', 'uri',
                                              'boolean', 'code', 'base64Binary',
                                              'Coding', 'CodeableConcept', 'Attachment',
                                              'Identifier', 'Quantity', 'Range', 'Period',
                                              'Ratio', 'HumanName', 'Address','Contact',
                                              'Schedule', 'Resource')" />

    <xsl:for-each select="$type">
      <xsl:variable name="currentType" select="." />

      <xsl:call-template name="output">
        <xsl:with-param name="path" select="replace($path, '\[x\]', fh:capitalize-first($currentType))" />
        <xsl:with-param name="type" select="$currentType" />
        <xsl:with-param name="min" select="$min" />
        <xsl:with-param name="max" select="$max" />
        <xsl:with-param name="weight" select="$weight" />
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>

  <!-- emits single <element> element -->
  <xsl:template name="output">
    <xsl:param name="path" />
    <xsl:param name="min" />
    <xsl:param name="max" />
    <xsl:param name="type" />
    <xsl:param name="weight" select="1" />
    <xsl:param name="nameRef" select="''" />

    <element>
      <xsl:attribute name="path"><xsl:value-of select="$path" /></xsl:attribute>
      <min><xsl:attribute name="value"><xsl:value-of select="$min" /></xsl:attribute></min>
      <max><xsl:attribute name="value"><xsl:value-of select="$max" /></xsl:attribute></max>
      <type>
        <xsl:if test="$type">
          <xsl:attribute name="value">
            <xsl:choose>
              <xsl:when test="$type = 'Resource'">
                <xsl:text>ResourceReference</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$type"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </xsl:if>
      </type>
      <nameRef>
        <xsl:if test="$nameRef">
          <xsl:attribute name="value">
            <xsl:value-of select="$nameRef" />
          </xsl:attribute>
        </xsl:if>
      </nameRef>
      <weight><xsl:attribute name="value"><xsl:value-of select="$weight" /></xsl:attribute></weight>
    </element>
  </xsl:template>

  <xsl:template match="//element">
    <xsl:variable name="type" select="definition/type/code/@value" />
    <xsl:variable name="path" select="path/@value" />
    <xsl:variable name="min" select="definition/min/@value" />
    <xsl:variable name="max" select="definition/max/@value" />
    <xsl:variable name="nameRef" select="definition/nameReference/@value" />
    <xsl:variable name="weight" select="position()" />

    <!-- Ignore extensions for now -->
    <xsl:if test="not(contains($path, '.extension'))">
      <xsl:choose>
        <xsl:when test="contains($path, '[x]')">
          <xsl:choose>
            <!-- do not pass type to expandPolymorphic template so all
                 availabe types will be used-->
            <xsl:when test="$type = '*'">
              <xsl:call-template name="expandPolymorphic">
                <xsl:with-param name="path" select="$path" />
                <xsl:with-param name="min" select="$min" />
                <xsl:with-param name="max" select="$max" />
                <xsl:with-param name="weight" select="$weight" />
              </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
              <xsl:call-template name="expandPolymorphic">
                <xsl:with-param name="path" select="$path" />
                <xsl:with-param name="type" select="$type" />
                <xsl:with-param name="min" select="$min" />
                <xsl:with-param name="max" select="$max" />
                <xsl:with-param name="weight" select="$weight" />
              </xsl:call-template>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="output">
            <xsl:with-param name="path" select="$path" />
            <xsl:with-param name="type" select="$type[1]" />
            <xsl:with-param name="min" select="$min" />
            <xsl:with-param name="max" select="$max" />
            <xsl:with-param name="nameRef" select="$nameRef" />
            <xsl:with-param name="weight" select="$weight" />
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template name="extractTypeElements">
    <xsl:param name="document" />
    <xsl:variable name="elements" select="$document//structure[1]/element" />

    <xsl:for-each-group select="$elements[contains(path/@value, '.')]" group-by="./path/@value">
      <xsl:call-template name="output">
        <xsl:with-param name="path" select="path/@value" />
        <xsl:with-param name="type" select="definition/type/code/@value" />
        <xsl:with-param name="min" select="definition/min/@value" />
        <xsl:with-param name="max" select="definition/max/@value" />
        <xsl:with-param name="weight" select="position()" />
      </xsl:call-template>
    </xsl:for-each-group>
  </xsl:template>

  <!-- do not output text nodes and attributes -->
  <xsl:template match="text()|@*">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- entry point -->
  <xsl:template match="/">
    <elements>
      <xsl:apply-templates />

      <xsl:call-template name="extractTypeElements">
        <xsl:with-param name="document"
                        select="document('build/profiles-types.xml')" />
      </xsl:call-template>
    </elements>
  </xsl:template>

</xsl:stylesheet>
