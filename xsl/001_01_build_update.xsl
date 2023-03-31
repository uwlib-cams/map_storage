<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:reg="http://metadataregistry.org/uri/profile/regap/"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:uwmaps="https://uwlib-cams.github.io/map_storage/xsd/"
    xmlns:uwsinopia="https://uwlib-cams.github.io/sinopia_maps/xsd/"
    xmlns:dcam="http://purl.org/dc/dcam/"
    xmlns:prov="http://www.w3.org/ns/prov#"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    version="3.0">
    
    <xsl:output method="xml" indent="yes"/>
    
    <xsl:param name="oxygenPath"/>
    
    <!-- Include named templates -->
    <xsl:include href="001_02_source_templates.xsl"/>
    
    
    
    <xsl:template match="/">
        <xsl:for-each select="uwmaps:get_prop_sets/uwmaps:get_set">
            <xsl:result-document href="{concat($oxygenPath, 'prop_set_', uwmaps:set_name, '.xml')}">
                <prop_set xmlns="https://uwlib-cams.github.io/map_storage/xsd/"
                    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                    xmlns:xs="http://www.w3.org/2001/XMLSchema"
                    xmlns:uwsinopia="https://uwlib-cams.github.io/sinopia_maps/xsd/"
                    xsi:schemaLocation="https://uwlib-cams.github.io/map_storage/xsd/ https://uwlib-cams.github.io/map_storage/xsd/prop_set.xsd">
                    <prop_set_label>
                        <xsl:value-of select="uwmaps:set_name"/>
                    </prop_set_label>
                    <xsl:choose>
                        <xsl:when test="starts-with(uwmaps:set_name, 'rda')">
                            <xsl:call-template name="get_rda">
                                <xsl:with-param name="get_set" select="."/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="starts-with(uwmaps:set_name, 'uwRdaExtension')">
                            <xsl:call-template name="get_uwRdaExtension">
                                <xsl:with-param name="get_set" select="."/>
                            </xsl:call-template>
                        </xsl:when>

                        <!-- to do : other templates for other sources -->
                        <xsl:otherwise>
                            <xsl:text>&#10;&#10;</xsl:text>
                            <xsl:text>ERROR - NO TEMPLATE ASSOCIATED WITH THIS SOURCE SET NAME</xsl:text>
                            <xsl:text>&#10;&#10;</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </prop_set>
            </xsl:result-document>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>