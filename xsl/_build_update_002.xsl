<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:reg="http://metadataregistry.org/uri/profile/regap/"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:uwmaps="https://uwlib-cams.github.io/map_storage/xsd/"
    xmlns:dcam="http://purl.org/dc/dcam/"
    version="3.0">
    
    <xsl:output method="xml" indent="yes"/>
    
    <!-- Include named templates -->
    <xsl:include href="source_templates.xsl"/>
    
    <xsl:template match="/">
        <xsl:for-each select="uwmaps:get_prop_sets/uwmaps:get_set">
            <xsl:result-document href="{concat('../../prop_set_', uwmaps:set_name, '.xml')}">
                <prop_set xmlns="https://uwlib-cams.github.io/map_storage/xsd/"
                    xsi:schemaLocation="https://uwlib-cams.github.io/map_storage/xsd/ https://uwlib-cams.github.io/map_storage/map_storage/xsd/prop_set.xsd"
                    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                    xmlns:xs="http://www.w3.org/2001/XMLSchema">
                    <prop_set_label>
                        <xsl:value-of select="uwmaps:set_name"/>
                    </prop_set_label>
                    <xsl:choose>
                        <xsl:when test="starts-with(uwmaps:set_name, 'rda')">
                            <xsl:call-template name="get_rda">
                                <xsl:with-param name="get_set" select="."/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="starts-with(uwmaps:set_name, 'dc')">
                            <xsl:call-template name="get_dcTerms">
                                <xsl:with-param name="get_set" select="."/>
                            </xsl:call-template>
                        </xsl:when>
                        <!-- to do : other templates for other sources -->
                        <xsl:otherwise>
                            <xsl:text>&#10;&#10;</xsl:text>
                            <xsl:text>ERROR - NO TEMPLATE ASSOCIATED WITH THIS SET NAME</xsl:text>
                            <xsl:text>&#10;&#10;</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </prop_set>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>