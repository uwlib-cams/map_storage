<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:reg="http://metadataregistry.org/uri/profile/regap/"
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
    xmlns:mapstor="https://uwlib-cams.github.io/map_storage/"
    version="3.0">
    
    <xsl:output method="xml" indent="yes"/>
    
    <!-- Include named templates -->
    <xsl:include href="source_templates.xsl"/>
    
    <xsl:template match="/">
        <!-- test
        <xsl:for-each select="document(mapstor:get_prop_sets/mapstor:get_set/mapstor:set_source)/rdf:RDF/rdf:Description">
            <xsl:value-of select="rdfs:label[@xml:lang='en']"/>
            <xsl:text>&#10;</xsl:text>
        </xsl:for-each>
        -->
        <xsl:for-each select="mapstor:get_prop_sets/mapstor:get_set">
            <xsl:result-document href="{concat('../../prop_set_', mapstor:set_name, '.xml')}">
                <prop_set xmlns="https://uwlib-cams.github.io/map_storage/"
                    xsi:schemaLocation="https://uwlib-cams.github.io/map_storage/ https://uwlib-cams.github.io/map_storage/map_storage.xsd"
                    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                    xmlns:xs="http://www.w3.org/2001/XMLSchema">
                    <xsl:choose>
                        <xsl:when test="starts-with(mapstor:set_name, 'rdac')">
                            <xsl:call-template name="get_rda">
                                <xsl:with-param name="get_set" select="."/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:when test="starts-with(mapstor:set_name, 'dc')">
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