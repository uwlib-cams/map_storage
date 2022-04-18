<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:uwmaps="https://uwlib-cams.github.io/map_storage/xsd/"
    xmlns:uwsinopia="https://uwlib-cams.github.io/sinopia_maps/xsd/"
    exclude-result-prefixes="xs uwmaps uwsinopia"
    version="3.0">
    
    <xsl:mode on-no-match="shallow-copy"/>
    
    <xsl:template match="uwmaps:prop_set/uwmaps:prop/uwmaps:sinopia/uwsinopia:implementation_set">
        <xsl:choose>
            <xsl:when test="@localid_implementation_set/text()"/>
            <xsl:otherwise>
                <!-- add some kind of property identification to the localid as well -->
                <uwsinopia:implementation_set 
                    localid_implementation_set="{concat(../../../../uwmaps:prop_set/uwmaps:prop_set_label, '_', generate-id())}">
                    <xsl:copy-of select="node()"/>
                </uwsinopia:implementation_set>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>