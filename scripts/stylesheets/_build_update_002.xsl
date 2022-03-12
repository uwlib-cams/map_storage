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
    <xsl:include href="rda_template.xsl"/>
    
    <xsl:template match="/">
        <xsl:for-each select="document(mapstor:get_prop_sets/mapstor:get_set/mapstor:set_source)/rdf:RDF/rdf:Description">
            <xsl:value-of select="rdfs:label[@xml:lang='en']"/>
            <xsl:text>&#10;</xsl:text>
        </xsl:for-each>
    </xsl:template>
    
</xsl:stylesheet>