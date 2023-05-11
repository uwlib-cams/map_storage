<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:uwmaps="https://uwlib-cams.github.io/map_storage/xsd/"
    xmlns:uwsinopia="https://uwlib-cams.github.io/sinopia_maps/xsd/"
    exclude-result-prefixes="xs uwmaps uwsinopia" version="3.0">

    <xsl:output method="xml" indent="1"/>
    <xsl:mode on-no-match="shallow-copy"/>

    <xsl:template match="//uwsinopia:toolkit[@url = '']">
        <xsl:variable name="rdaPropertyNumber" select="
                concat('rda',
                substring-after(../../uwmaps:prop_iri/@iri, 'http://rdaregistry.info/Elements/')
                => replace('/', ':'))"/>
        <uwsinopia:toolkit
            url="{document('../xml/RDA_alignments.xml')/alignmentPairs/alignmentPair
            [rdaPropertyNumber = $rdaPropertyNumber]/rdaToolkitURL/@uri}">
            <xsl:copy-of select="node()"/>
        </uwsinopia:toolkit>
    </xsl:template>

</xsl:stylesheet>
