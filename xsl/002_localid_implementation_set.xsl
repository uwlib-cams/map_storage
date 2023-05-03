<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:uwmaps="https://uwlib-cams.github.io/map_storage/xsd/"
    xmlns:uwsinopia="https://uwlib-cams.github.io/sinopia_maps/xsd/"
    exclude-result-prefixes="xs uwmaps uwsinopia"
    version="3.0">
    
    <xsl:output method="xml" indent="1"/>
    
    <xsl:mode on-no-match="shallow-copy"/>
    
    <xsl:template match="//uwsinopia:implementation_set[@localid_implementation_set = '']">
        <uwsinopia:implementation_set
            localid_implementation_set="{concat(../../@localid_prop, '_is_', generate-id())}">
            <xsl:copy-of select="node()"/>
        </uwsinopia:implementation_set>
    </xsl:template>
    
</xsl:stylesheet>