<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:uwmaps="https://uwlib-cams.github.io/map_storage/xsd/"
    xmlns:uwsinopia="https://uwlib-cams.github.io/sinopia_maps/xsd/"
    exclude-result-prefixes="xs uwmaps uwsinopia" version="3.0">

    <xsl:include href="003_01_convert_csv_to_xml.xsl"/>

    <xsl:output method="xml" indent="1"/>

    <xsl:mode on-no-match="shallow-copy"/>

    <xsl:template match="uwmaps:prop_set/uwmaps:prop/uwmaps:sinopia/uwsinopia:implementation_set">
        <xsl:choose>
            <xsl:when test="uwsinopia:remark_url/@iri">
                <xsl:copy-of select="."/>
            </xsl:when>
            <xsl:otherwise>
                <uwsinopia:implementation_set localid_implementation_set="{@localid_implementation_set}">
                    <xsl:copy-of select="uwsinopia:institution"/>
                    <xsl:copy-of select="uwsinopia:resource"/>
                    <xsl:copy-of select="uwsinopia:format"/>
                    <xsl:copy-of select="uwsinopia:user"/>
                    <xsl:copy-of select="uwsinopia:form_order"/>
                    <xsl:if test="uwsinopia:multiple_prop">
                        <xsl:copy-of select="uwsinopia:multiple_prop"/>
                    </xsl:if>

                    <xsl:variable name="prop_iri" select="../../uwmaps:prop_iri/@iri"/>
                    <xsl:variable name="last_8_characters"
                        select="substring-after($prop_iri, 'http://rdaregistry.info/Elements/')"/>
                    <xsl:variable name="prop_id"
                        select="concat('rda', replace($last_8_characters, '/', ':'))"/>
                    <xsl:variable name="alignment" select="document('../xml/RDA_alignments.xml')"/>
                    <xsl:variable name="toolkit_url"
                        select="$alignment/alignmentPairs/alignmentPair[rdaPropertyNumber = $prop_id]/rdaToolkitURL/@uri"/>

                    <uwsinopia:remark_url iri="{$toolkit_url}"/>

                    <xsl:if test="uwsinopia:remark">
                        <xsl:copy-of select="uwsinopia:remark"/>
                    </xsl:if>
                    <xsl:if test="uwsinopia:language_suppressed">
                        <xsl:copy-of select="uwsinopia:language_suppressed"/>
                    </xsl:if>
                    <xsl:if test="uwsinopia:required">
                        <xsl:copy-of select="uwsinopia:required"/>
                    </xsl:if>
                    <xsl:if test="uwsinopia:repeatable">
                        <xsl:copy-of select="uwsinopia:repeatable"/>
                    </xsl:if>
                    <xsl:if test="uwsinopia:literal_pt">
                        <xsl:copy-of select="uwsinopia:literal_pt"/>
                    </xsl:if>
                    <xsl:if test="uwsinopia:uri_pt">
                        <xsl:copy-of select="uwsinopia:uri_pt"/>
                    </xsl:if>
                    <xsl:if test="uwsinopia:lookup_pt">
                        <xsl:copy-of select="uwsinopia:lookup_pt"/>
                    </xsl:if>
                    <xsl:if test="uwsinopia:nested_resource_pt">
                        <xsl:copy-of select="uwsinopia:nested_resource_pt"/>
                    </xsl:if>
                </uwsinopia:implementation_set>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
